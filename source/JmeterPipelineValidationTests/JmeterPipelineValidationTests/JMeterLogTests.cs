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
            //act
            Assert.IsTrue(File.Exists(Config.Configuration["jmeterLogFileName"]));
            string jmeterLogFileName = Config.Configuration["jmeterLogFileName"];
            var logFileContents = File.ReadAllText(jmeterLogFileName);
            bool failedMessageFound = logFileContents.Contains(failMessage);
            //assert
            Assert.IsTrue(!failedMessageFound);
        }

        [TestMethod]
        public void ErrorPercentageLessThanTarget()
        {

            //arrange
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
        
        [TestMethod]
        public void AverageAndLabel()
        {
            //arrange
            string statisticsFileName = Config.Configuration["statisticsFileName"];

            //act
            JObject rss = JObject.Parse(File.ReadAllText(statisticsFileName));

            //retrieving average
            float average;
            string averageString = (string)rss["Home Page-0"]["meanResTime"];
            float.TryParse(averageString, out average);
            bool averageIsOkay = average > 0;

            //retrieving label
            string label = (string)rss["Home Page-0"]["transaction"];
            bool labelIsOkay = !label.Equals("", StringComparison.OrdinalIgnoreCase);

            //assert
            Assert.IsTrue(averageIsOkay && labelIsOkay);
        }
    }
}
