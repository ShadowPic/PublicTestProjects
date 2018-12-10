using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace DynamicsOdataTests
{
    [TestClass]
    public class ConfigurationBuilderTests
    {
        [TestMethod]
        public void VerifySetting()
        {

            //arrange
            string expectedValue = "from configbuilder";
            string actualValue = "not from configbuilder";
            //act
            actualValue = System.Configuration.ConfigurationSettings.AppSettings["TestConfig"];
            //assert
            Assert.AreEqual(actualValue, expectedValue);
        }
    }
}
