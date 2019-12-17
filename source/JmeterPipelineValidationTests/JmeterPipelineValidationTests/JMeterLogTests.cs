using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;

namespace JmeterPipelineValidationTests
{
    [TestClass]
    public class JMeterLogTests
    {
        
        [TestMethod]
        public void AutoStopListenerDidNotFire()
        {

            //arrange
            string failMessage = "AutoStop: Sending StopTestNow request to port 4445";
            string currentConfig = File.ReadAllText("apsettings.json");
            File.WriteAllText("apsettings.json", currentConfig.Replace(@"\", @"\\"));

            string jmeterLogFileName = Config.Configuration["jmeterLogFileName"].Replace(@"\",@"\\");
            //act
            var logFileContents = File.ReadAllText(jmeterLogFileName);
            bool failedMessageFound = logFileContents.Contains(failMessage);
            //assert
            Assert.IsTrue(!failedMessageFound);
        }

        [TestMethod]
        public void ErrorPercentageLessThanTarget()
        {

            //arrange
            string currentConfig = File.ReadAllText("apsettings.json");
            File.WriteAllText("apsettings.json", currentConfig.Replace(@"\", @"\\"));
            string statisticsFileName = Config.Configuration["statisticsFileName"];
            string expectedMaxString = Config.Configuration["expectedKoMax"];
            float expectedMax;
            float.TryParse(expectedMaxString,out expectedMax);
            
            //act
            JObject rss = JObject.Parse(File.ReadAllText(statisticsFileName));
            float errorPercentage;
            string errorPercentageString = (string) rss["Total"]["errorPct"];
            float.TryParse(errorPercentageString, out errorPercentage);
            bool koIsOk = errorPercentage < expectedMax;
            //assert
            Assert.IsTrue(koIsOk);
        }
    }
}
