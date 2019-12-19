using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;

namespace JmeterPipelineValidationTests
{
    [TestClass]
    public class GenerateReportTests
    {
        [TestMethod]
        public void GenerateReport()
        {
            //arrange
            string resultsJsonFile = Config.Configuration["statisticsFileName"];

            //act
            JObject resultsJson = JObject.Parse(File.ReadAllText(resultsJsonFile));
            string markdownTemplate =
                $"# JMeter Performance Test Results\r\n" +
                $"\r\n" +
                $"| Measure      | Value |\r\n"+
                $"| ----------- | ----------- |\r\n" +
                $"| Average Response Time | {resultsJson["Total"]["meanResTime"]} |\r\n" +
                $"| Sample Count | {resultsJson["Total"]["sampleCount"]} |\r\n";
            File.WriteAllText(@"report.md", markdownTemplate);
            //assert

        }
        
    }
}
