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
            string jmeterLogFileName = Config.Configuration["jmeterLogFileName"];
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
            string failMessage = "AutoStop: Sending StopTestNow request to port 4445";
            string statisticsFileName = Config.Configuration["statisticsFileName"];
            float expectedMax = 30.0f;
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
