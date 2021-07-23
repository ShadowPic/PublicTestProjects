using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using JtlToSql;

namespace FileJtlToSql
{
    class Program
    {
        public Program()
        {

        }
        static Task Main(string[] args)
        {
            IHost host = Host.CreateDefaultBuilder(args).Build();

            var logger = host.Services.GetRequiredService<ILogger<Program>>();

            logger.LogInformation("Host created.");
            var storageConnectionString = Environment.GetEnvironmentVariable("JtlReportingStorage");
            string resultsJtlBlobPath = null;
            QueueClient queueClient = new QueueClient(storageConnectionString, "JtlPendingReports".ToLower());
            if (queueClient.Exists())
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
            logger.LogInformation("All done by by.");
            return host.RunAsync();

        }
    }
}


