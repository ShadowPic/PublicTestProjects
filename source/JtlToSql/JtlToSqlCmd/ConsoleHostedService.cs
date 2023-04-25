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

namespace JtlToSqlCmd
{
    public class ConsoleHostedService : IHostedService
    {
        const string NO_TEST_PLAN = "no test plan";
        const string NO_TEST_RUN = "no test run";
        CancellationToken commonCancellationToken;
        public class Options
        {
            [Option("testplan", Required = false, HelpText = "Test plan name", Default = NO_TEST_PLAN)]
            public string TestPlan { get; set; }
            [Option("testrun", Required = false, HelpText = "Test run to delete", Default = NO_TEST_RUN)]
            public string TestRun { get; set; }
            [Option("jtlfile", Required = true, HelpText = "name of the jtl file to upload")]
            public string JtlFile { get; set; }
            [Option("jtlreportingdatabase", Required = true, HelpText = "Connection string to the reporting database")]
            public string JtlReportingDatabase { get; set; }
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
                DeleteReportsFromDatabase(options);

            }

            try
            {
                SendResultsToSql(options);
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

        void SendResultsToSql(Options options)
        {
            logger.LogInformation($"Opening JTL FILE {options.JtlFile}");

            using var csvJtl = new CsvJtl(options.JtlFile,options.TestPlan,options.TestRun);
            logger.LogInformation("Connecting to the Sql reporting dB");
            using var jtlCsvToSql = new JtlCsvToSql(options.JtlReportingDatabase);
            csvJtl.InitJtlReader(options.JtlFile);
            
            logger.LogInformation($"Deleting existing report for test plan '{csvJtl.TestPlan}' and test run '{options.TestRun}'");
            //TODO:fix this
            jtlCsvToSql.DeleteReport(csvJtl.TestPlan, options.TestRun);
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



        private void DeleteReportsFromDatabase(Options options)
        {
            // Making connection to database
            var sqlConnectionString = options.JtlReportingDatabase;
            var testPlan = options.TestPlan;
            var testRun = options.TestRun;
            // Checking if test plan and test run is in database
            logger.LogInformation("Connecting to the Sql reporting dB");
            using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
            if (JtlCsvToSql.ReportAlreadyProcessed(testPlan, testRun, sqlConnectionString))
            {
                logger.LogInformation($"Test run '{testRun}' for test plan '{testPlan}' found in database.");
                jtlCsvToSql.DeleteReport(testPlan, testRun);
                logger.LogInformation($"Removing Test run '{testRun}' for test plan '{testPlan}' from the database.");
            }
            else
                logger.LogWarning($"Test run '{testRun}' for test plan '{testPlan}' not found in database.");
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
