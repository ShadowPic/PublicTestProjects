using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using JtlToSql;
using System;
using System.Collections.Generic;

namespace JtlToSqlTests
{
    [TestClass]
    public class JtlCsvToSqlTests
    {
        [TestMethod]
        public void SendAllRows()
        {
            //arrange
            string connectionString = "Server=tcp:jmeterreporting.database.windows.net,1433;Initial Catalog=jmeterreporting;Persist Security Info=False;User ID=jmeteradmin;Password=REDACTED;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
            string pathToJtlFile = "chauncee test/2021/06/14/20210614T1755279470Zresults/results.jtl";
            string demoJtlFileName = "results.jtl";
            string expectedTestName = "chauncee test";
            string expectedTestRun = "20210614T1755279470Zresults";
            using var csvJtl = new CsvJtl(pathToJtlFile);
            using var jtlCsvToSql = new JtlCsvToSql(connectionString);
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
            Assert.IsTrue(j > 1000);
        }
    }
}
