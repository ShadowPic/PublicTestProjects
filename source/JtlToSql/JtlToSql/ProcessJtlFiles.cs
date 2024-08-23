using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
namespace JtlToSql
{
    public class ProcessJtlFiles
    {
        public ProcessJtlFiles() { }

        public void PostProcess()
        {

        }

        public void SendJtlToSQL(string jtlFilePath, string sqlConnectionString, string testPlan, string testRun)
        {
            using ILoggerFactory factory = LoggerFactory.Create(builder => builder.AddConsole());
            ILogger logger = factory.CreateLogger("Program");
            logger.LogInformation($"Opening JTL FILE {jtlFilePath}");

            using var csvJtl = new CsvJtl(jtlFilePath, testPlan, testRun);
            logger.LogInformation("Connecting to the Sql reporting dB");
            using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
            bool reportAlreadyProcessed = JtlCsvToSql.ReportAlreadyProcessed(csvJtl.TestPlan, csvJtl.TestRun, sqlConnectionString);
            if (reportAlreadyProcessed) jtlCsvToSql.DeleteReport(csvJtl.TestPlan, csvJtl.TestRun); 
            csvJtl.InitJtlReader(jtlFilePath);
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
                logger.LogInformation("Post processing");
                jtlCsvToSql.PostProcess();
            }
            else
            {
                logger.LogInformation($"The test run {csvJtl.TestRun} for test plan {csvJtl.TestPlan} is already in sql.  Skipping.");
            }

        }
    }
}
