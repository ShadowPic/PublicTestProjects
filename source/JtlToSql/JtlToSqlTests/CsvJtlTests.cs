using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using JtlToSql;
using System;
using System.Collections.Generic;

namespace JtlToSqlTests
{
    [TestClass]
    public class CsvJtlTests
    {
        [TestMethod]
        public void SplitOutTransactionMetrics()
        {
            //arrange
            var responseMessage = "Number of samples in transaction : 2, number of failing samples : 0";
            var expectedSamples = 2;
            var expectedFailures = 0;
            //act
            var samples = int.Parse( responseMessage.Split(",")[0].Split(":")[1].Trim());
            var failures = int.Parse(responseMessage.Split(",")[1].Split(":")[1].Trim());
            //assert
            Assert.AreEqual(expectedSamples, samples);
            Assert.AreEqual(expectedFailures, failures);
        }
        [TestMethod]
        public void ReadJtlFile()
        {
            //arrange
            string demoJtlFileName = "results.jtl";
            using var csvJtl = new CsvJtl();
            //act
            using Stream jtlStream =File.OpenRead(demoJtlFileName);
            using StreamReader jtlStreamReader = new StreamReader(jtlStream);
            csvJtl.InitJtlReader(jtlStreamReader);
            int i = 0;
            while(csvJtl.ReadNextCsvLine())
            {
                var csvRow = csvJtl.GetCsvRow();
                i++;
            }
            //assert
            Assert.IsTrue(i > 100);
        }

        [TestMethod]
        public void AddElapsedTime()
        {
            //arrange
            string demoJtlFileName = "results.jtl";
            using var csvJtl = new CsvJtl();
            //act
            using Stream jtlStream = File.OpenRead(demoJtlFileName);
            using StreamReader jtlStreamReader = new StreamReader(jtlStream);
            csvJtl.InitJtlReader(jtlStreamReader);
            int i = 0;
            int elapsedMilliseconds = 0;
            while (csvJtl.ReadNextCsvLine())
            {
                var csvRow = csvJtl.GetCsvRow();
                elapsedMilliseconds = csvRow.ElapsedMS;
                i++;
            }
            //assert
            Console.WriteLine($"elapsed milliseconds was {elapsedMilliseconds}");
            Assert.IsTrue(elapsedMilliseconds > 0);
        }
        [TestMethod]
        public void BurstResultsPath()
        {
            //arrange
            string pathToJtlFile = "chauncee test/2021/06/14/20210614T1755279470Zresults/results.jtl";
            string demoJtlFileName = "results.jtl";
            string expectedTestName = "chauncee test";
            string expectedTestRun = "20210614T1755279470Zresults";
            using var csvJtl = new CsvJtl(pathToJtlFile);
            //act
            using Stream jtlStream = File.OpenRead(demoJtlFileName);
            using StreamReader jtlStreamReader = new StreamReader(jtlStream);
            csvJtl.InitJtlReader(jtlStreamReader);
            csvJtl.ReadNextCsvLine();
            var csvRow = csvJtl.GetCsvRow();
            var csvDict = csvRow as IDictionary<string,object>;
            foreach(var row in csvDict)
            {
                Console.WriteLine($"Key:{row.Key},value:{row.Value}");
            };
            //assert
            Assert.AreEqual(expectedTestName,csvRow.TestPlan);
            Assert.AreEqual(expectedTestRun, csvRow.TestRun);
        }
    }
}
