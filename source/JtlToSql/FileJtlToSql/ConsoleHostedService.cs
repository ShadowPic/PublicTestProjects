using Azure.Storage.Blobs;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;
using JtlToSql;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using CommandLine;
using System.Collections.Generic;

namespace FileJtlToSql
{
    public class ConsoleHostedService : IHostedService
    {
        public class Options
        {
            [Option("testplan", Required = false, HelpText = "Test plan name")]
            public string TestPlan { get; set; }
            [Option("testrun", Required = false, HelpText = "Test run to delete")]
            public string TestRun { get; set; }
        }

        private readonly ILogger logger;
        private readonly IHostApplicationLifetime _appLifetime;

        public ConsoleHostedService(
            ILogger<ConsoleHostedService> logger,
            IHostApplicationLifetime appLifetime)
        {
            this.logger = logger;
            _appLifetime = appLifetime;
        }
        CancellationToken commonCancellationToken;
        public Task StartAsync(CancellationToken cancellationToken)
        {
            _appLifetime.ApplicationStarted.Register(() =>
            {
                Task.Run(async () =>
                {
                    commonCancellationToken = cancellationToken;
                    var commandLineArguments = Environment.GetCommandLineArgs();
                    _ = CommandLine.Parser.Default.ParseArguments<Options>(commandLineArguments)
                        .WithParsedAsync(RunWithOptions);


                });
            });

            return Task.CompletedTask;
        }

        async Task RunWithOptions(Options options)
        {
            Console.WriteLine("I see dead people");
            if (options.TestPlan != null && options.TestRun != null)
            {
                DeleteReportsFromDatabase(testPlan: options.TestPlan, testRun: options.TestRun);
                _appLifetime.StopApplication();
                return;
            }

            try
            {
                bool runOnceAndStop = false;
                bool alreadyGotTheResults = false;

                while (!commonCancellationToken.IsCancellationRequested && !runOnceAndStop)
                {
                    runOnceAndStop = Environment.GetEnvironmentVariable("RunOnceAndStop") != null ? bool.Parse(Environment.GetEnvironmentVariable("RunOnceAndStop")) : false;
                    var sqlConnectionString = Environment.GetEnvironmentVariable("JtlReportingDatabase");
                    var storageConnectionString = Environment.GetEnvironmentVariable("JtlReportingStorage");
                    logger.LogInformation("Checking for the existence of the JtlPendingReports storage queue.");
                    QueueClient queueClient = new QueueClient(storageConnectionString, "JtlPendingReports".ToLower());
                    queueClient.CreateIfNotExists();
                    if (queueClient.Exists())
                    {
                        logger.LogInformation("The JtlPendingReports queue exists.");
                        logger.LogInformation("Checking to see if there are any messages to process.");
                        if ((queueClient.PeekMessages().Value.Length == 0) && !alreadyGotTheResults)
                        {
                            AddResultsToTheQueue(queueClient, storageConnectionString, sqlConnectionString);
                            alreadyGotTheResults = true;
                        }
                        SendResultsToSql(queueClient: queueClient, storageConnectionString: storageConnectionString, sqlConnectionString: sqlConnectionString);
                    }
                    if (!runOnceAndStop)
                    {
                        logger.LogInformation("Hanging out for 15 seconds.");
                        await Task.Delay(15000, commonCancellationToken);
                    }
                }
                logger.LogInformation("All done by by.");
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Unhandled exception!");
                throw;
            }
            finally
            {
                // Stop the application once the work is done
                _appLifetime.StopApplication();
            }
        }

        void AddResultsToTheQueue(QueueClient queueClient, string storageConnectionString, string sqlConnectionString)
        {
            logger.LogInformation("Checking to see if there are any messages to process.");

            logger.LogInformation("Adding all of the results to the queue");
            BlobContainerClient jmeterResultsContainer = new BlobContainerClient(storageConnectionString, "jmeterresults");
            foreach (var jmeterResultsBlobItem in jmeterResultsContainer.GetBlobs())
            {
                if (jmeterResultsBlobItem.Name.EndsWith("results.jtl", StringComparison.OrdinalIgnoreCase))
                {
                    string testPlan = CsvJtl.ExtractTestPlan(jmeterResultsBlobItem.Name);
                    string testRun = CsvJtl.ExtractTestRun(jmeterResultsBlobItem.Name);
                    logger.LogInformation($"Checking if test run {testRun} for test plan {testPlan} has already been added to Sql.");
                    if (!JtlCsvToSql.ReportAlreadyProcessed(testPlan, testRun, sqlConnectionString))
                    {
                        logger.LogInformation($"There is no report for test run {testRun} for test plan {testPlan}. Sending a message.");
                        logger.LogInformation($"Adding {jmeterResultsBlobItem.Name}");
                        var resultsJtlBlobPathBytes = Encoding.UTF8.GetBytes(jmeterResultsBlobItem.Name);
                        queueClient.SendMessage(Convert.ToBase64String(resultsJtlBlobPathBytes));
                    }
                }
            }
        }

        void SendResultsToSql(QueueClient queueClient, string storageConnectionString, string sqlConnectionString)
        {
            while (queueClient.PeekMessages().Value.Length > 0)
            {
                logger.LogInformation("Checking for new messages");
                // Get the next message
                QueueMessage[] retrievedMessages = queueClient.ReceiveMessages();
                if (retrievedMessages == null || retrievedMessages.Length == 0)
                {
                    logger.LogInformation("No messages to process.");

                }
                else
                {
                    string resultsJtlBlobPath = null;
                    string csvFileName = $"{Guid.NewGuid()}.csv";
                    try
                    {
                        resultsJtlBlobPath = Encoding.UTF8.GetString(Convert.FromBase64String(retrievedMessages[0].Body.ToString()));
                        logger.LogInformation($"Downloading {resultsJtlBlobPath}");
                        BlobClient blobClient = new BlobClient(storageConnectionString, "jmeterresults", resultsJtlBlobPath);
                        blobClient.DownloadTo(csvFileName);
                        // Delete the message
                        queueClient.DeleteMessage(retrievedMessages[0].MessageId, retrievedMessages[0].PopReceipt);
                        logger.LogInformation($"Opening JTL FILE {resultsJtlBlobPath}");

                        using var csvJtl = new CsvJtl(resultsJtlBlobPath);
                        logger.LogInformation("Connecting to the Sql reporting dB");
                        using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
                        csvJtl.InitJtlReader(csvFileName);
                        if (!JtlCsvToSql.ReportAlreadyProcessed(csvJtl.TestPlan, csvJtl.TestRun, sqlConnectionString))
                        {
                            logger.LogInformation($"Deleting existing report for test plan {csvJtl.TestPlan} and test run {csvJtl.TestRun}");
                            jtlCsvToSql.DeleteReport(csvJtl.TestPlan, csvJtl.TestRun);
                            logger.LogInformation("Sending results to SQL Server");
                            int i = 0;
                            while (csvJtl.ReadNextCsvLine())
                            {
                                var csvRow = csvJtl.GetCsvRow();
                                try
                                {
                                    if (i > 10000)
                                    {
                                        logger.LogInformation($"Committing {i} rows to sql for {csvJtl.TestRun}");
                                        jtlCsvToSql.CommitBatch();
                                        i = 0;
                                    }
                                    jtlCsvToSql.AddJtlRow(csvRow);
                                    i++;
                                }
                                catch (Exception e)
                                { logger.LogWarning($"Skipping line {e.ToString()}"); }
                            }
                            logger.LogInformation("Successfully added rows to database.  Now adding test report");
                            jtlCsvToSql.AddReport(csvJtl.TestPlan, csvJtl.TestRun, csvJtl.TestStartTime);
                        }
                        else
                        {
                            logger.LogInformation($"The test run {csvJtl.TestRun} for test plan {csvJtl.TestPlan} is already in sql.  Skipping.");
                        }

                    }
                    catch (Exception e)
                    {
                        logger.LogError(e.ToString());
                        logger.LogWarning($"Adding report back to the queue for path: {resultsJtlBlobPath}");
                        var resultsJtlBlobPathBytes = Encoding.UTF8.GetBytes(resultsJtlBlobPath);
                        queueClient.SendMessage(Convert.ToBase64String(resultsJtlBlobPathBytes));
                    }
                    finally
                    {
                        File.Delete(csvFileName);
                    }
                }
            }
        }
       
        private void DeleteReportsFromDatabase(String testPlan, string testRun)
        {
            // Making connection to database
            var sqlConnectionString = Environment.GetEnvironmentVariable("JtlReportingDatabase");

            // Checking if test plan and test run is in database
            logger.LogInformation("Connecting to the Sql reporting dB");
            using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
            if (JtlCsvToSql.ReportAlreadyProcessed(testPlan, testRun, sqlConnectionString))
            {
                logger.LogInformation($"Test run {testRun} for test plan {testPlan} found in database.");
                jtlCsvToSql.DeleteReport(testPlan, testRun);
                logger.LogInformation($"Removing Test run {testRun} for test plan {testPlan} from the database.");
            }
            else
                logger.LogWarning($"Test run {testRun} for test plan {testPlan} not found in database.");
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
