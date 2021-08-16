using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using JtlToSql;
using System;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace JtlToSqlTests
{
    [TestClass]
    public class JtlCsvToSqlTests
    {
        [TestMethod]
        public void SendAllRows()
        {
            //arrange
            var secrets = new ConfigurationBuilder()
                .AddUserSecrets<Settings>()
                .Build();
            string sqlConnectionString = secrets["JtlReportingDatabase"];
            string pathToJtlFile = "chauncee test/2021/06/14/20210614T1755279470Zresults/results.jtl";
            string demoJtlFileName = "results.jtl";
            string expectedTestName = "chauncee test";
            string expectedTestRun = "20210614T1755279470Zresults";
            using var csvJtl = new CsvJtl(pathToJtlFile);
            using var jtlCsvToSql = new JtlCsvToSql(sqlConnectionString);
            //act
            using Stream jtlStream = File.OpenRead(demoJtlFileName);
            using StreamReader jtlStreamReader = new StreamReader(jtlStream);
            csvJtl.InitJtlReader(jtlStreamReader);
            jtlCsvToSql.DeleteReport(csvJtl.TestPlan, csvJtl.TestRun);
            int i = 0;
            int j = 0;
            while (csvJtl.ReadNextCsvLine())
            {
                var csvRow = csvJtl.GetCsvRow();
                jtlCsvToSql.AddJtlRow(csvRow);
                if(i>10000)
                {
                    Console.WriteLine($"Sending {i} records");
                    jtlCsvToSql.CommitBatch();
                    i = 0;
                }
                //try
                //{
                //    jtlCsvToSql.AddJtlRow(csvRow);
                //}
                //catch (Exception e)
                //{
                //    Console.WriteLine($"Skipping line {e.ToString()}");
                //    System.Diagnostics.Debugger.Break();
                //}
                i++;
                j++;
            }
            jtlCsvToSql.AddReport(csvJtl.TestPlan, csvJtl.TestRun, csvJtl.TestStartTime);
            //assert
            bool reportWasFiled = JtlCsvToSql.ReportAlreadyProcessed(csvJtl.TestPlan, csvJtl.TestRun,sqlConnectionString);
            jtlCsvToSql.DeleteReport(csvJtl.TestPlan, csvJtl.TestRun);
            Assert.IsTrue(j > 1000);
            Assert.IsTrue(reportWasFiled);
        }
    }
}
