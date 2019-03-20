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
#pragma warning disable CS0618 // Type or member is obsolete
            actualValue = System.Configuration.ConfigurationSettings.AppSettings["TestConfig"];
#pragma warning restore CS0618 // Type or member is obsolete
                              //assert
            Assert.AreEqual(actualValue, expectedValue);
        }
    }
}
