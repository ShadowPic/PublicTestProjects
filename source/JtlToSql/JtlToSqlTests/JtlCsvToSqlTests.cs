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
        public void SendASingleRow()
        {
            //arrange
            string connectionString = "Server=tcp:jmeterreporting.database.windows.net,1433;Initial Catalog=jmeterreporting;Persist Security Info=False;User ID=jmeteradmin;Password=ASDFasdf1234;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
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
            csvJtl.ReadNextCsvLine();
            var csvRow = csvJtl.GetCsvRow();
            csvJtl.AddCalculatedColumns(csvRow);
            var csvDict = csvRow as IDictionary<string,object>;
            jtlCsvToSql.AddJtlRow(csvRow);
            //assert
            Assert.AreEqual(expectedTestName,csvRow.TestPlan);
            Assert.AreEqual(expectedTestRun, csvRow.TestRun);
        }
        [TestMethod]
        public void SendAllRows()
        {
            //arrange
            string connectionString = "Server=tcp:jmeterreporting.database.windows.net,1433;Initial Catalog=jmeterreporting;Persist Security Info=False;User ID=jmeteradmin;Password=ASDFasdf1234;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
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
            int i = 0;
            while (csvJtl.ReadNextCsvLine())
            {
                var csvRow = csvJtl.GetCsvRow();

                try
                {
                    csvJtl.AddCalculatedColumns(csvRow);
                    jtlCsvToSql.AddJtlRow(csvRow);
                }
                catch (Exception e)
                { Console.WriteLine($"Skipping line {e.ToString()}"); }
                i++;
            }
            //assert
            Assert.IsTrue(i > 1000);
        }
    }
}
