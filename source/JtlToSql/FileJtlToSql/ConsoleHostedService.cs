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

namespace FileJtlToSql
{
    internal sealed class ConsoleHostedService : IHostedService
    {
        private readonly ILogger logger;
        private readonly IHostApplicationLifetime _appLifetime;

        public ConsoleHostedService(
            ILogger<ConsoleHostedService> logger,
            IHostApplicationLifetime appLifetime)
        {
            this.logger = logger;
            _appLifetime = appLifetime;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            logger.LogDebug($"Starting with arguments: {string.Join(" ", Environment.GetCommandLineArgs())}");

            _appLifetime.ApplicationStarted.Register(() =>
            {
                Task.Run(async () =>
                {
                    try
                    {
                        bool alreadyGotTheResults = false;
                        while (!cancellationToken.IsCancellationRequested)
                        {
                            logger.LogInformation("Checking for the existence of the JtlPendingReports storage queue.");
                            var storageConnectionString = Environment.GetEnvironmentVariable("JtlReportingStorage");
                            string resultsJtlBlobPath = null;
                            QueueClient queueClient = new QueueClient(storageConnectionString, "JtlPendingReports".ToLower());
                            if (queueClient.Exists())
                            {
                                logger.LogInformation("The JtlPendingReports queue exists.");
                                logger.LogInformation("Checking to see if there are any messages to process.");
                                if((queueClient.PeekMessages().Value.Length == 0) && ! alreadyGotTheResults)
                                {
                                    logger.LogInformation("Adding all of the results to the queue");
                                    BlobContainerClient jmeterResultsContainer = new BlobContainerClient(storageConnectionString, "jmeterresults");
                                    foreach(var jmeterResultsBlobItem in jmeterResultsContainer.GetBlobs())
                                    {
                                        if(jmeterResultsBlobItem.Name.EndsWith("results.jtl", StringComparison.OrdinalIgnoreCase))
                                        {
                                            logger.LogInformation($"Adding {jmeterResultsBlobItem.Name}");
                                            var resultsJtlBlobPathBytes = Encoding.UTF8.GetBytes(jmeterResultsBlobItem.Name);
                                            queueClient.SendMessage(Convert.ToBase64String(resultsJtlBlobPathBytes));
                                        }
                                    }
                                    alreadyGotTheResults = true;
                                }
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
                                            var sqlConnectionString = Environment.GetEnvironmentVariable("JtlReportingDatabase");
                                            using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
                                            csvJtl.InitJtlReader(csvFileName);
                                            if (!jtlCsvToSql.ReportAlreadyProcessed(csvJtl.TestPlan, csvJtl.TestRun))
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
                            logger.LogInformation("Hanging out for 15 seconds.");
                            await Task.Delay(15000,cancellationToken);
                        }
                        logger.LogInformation("All done by by.");
                    }
                    catch (Exception ex)
                    {
                        logger.LogError(ex, "Unhandled exception!");
                    }
                    finally
                    {
                        // Stop the application once the work is done
                        _appLifetime.StopApplication();
                    }
                });
            });

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
