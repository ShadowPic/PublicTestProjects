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
            var sqlConnectionString = Environment.GetEnvironmentVariable("JtlReportingDatabase");
            var storageConnectionString = Environment.GetEnvironmentVariable("JtlReportingStorage");

            QueueClient queueClient = new QueueClient(storageConnectionString, "JtlPendingReports".ToLower());
            if (queueClient.Exists())
            {
                // Get the next message
                QueueMessage[] retrievedMessages = queueClient.ReceiveMessages();
                if (retrievedMessages == null || retrievedMessages.Length == 0)
                {
                    logger.LogInformation("No messages to process.");

                }
                else
                {
                    string name = Encoding.UTF8.GetString(Convert.FromBase64String(retrievedMessages[0].Body.ToString()));
                    // Process (i.e. print) the message in less than 30 seconds
                    BlobClient blobClient = new BlobClient(storageConnectionString, "jmeterresults", name);
                    string csvFileName = $"{Guid.NewGuid()}.csv";
                    blobClient.DownloadTo(csvFileName);
                    // Delete the message
                    queueClient.DeleteMessage(retrievedMessages[0].MessageId, retrievedMessages[0].PopReceipt);

                    logger.LogInformation($"Opening JTL FILE {name}");
                    try
                    {
                        using var csvJtl = new CsvJtl(name);
                        using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
                        csvJtl.InitJtlReader(csvFileName);
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
                    }
                    finally
                    {
                        File.Delete(csvFileName);
                    }
                }
            }

            return host.RunAsync();

        }
    }
}
