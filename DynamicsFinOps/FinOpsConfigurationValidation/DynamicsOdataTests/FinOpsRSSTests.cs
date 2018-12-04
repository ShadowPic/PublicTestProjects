using Microsoft.VisualStudio.TestTools.UnitTesting;
using DynamicsOdata;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using System.Linq;

namespace DynamicsOdataTests
{
    [TestClass()]
    public class FinOpsRSSTests
    {
        public static TestContext TC;

        [ClassInitialize]
        public static void InitializeTestClass(TestContext tc)
        {
            TC = tc;
        }

        [TestMethod()]
        public void FinOpsRSSTest()
        {
            //arrange
            FinOpsRSS finOpsRSS = RSSUtil.CreateRssFromConfig();
            //act
            JObject rss = finOpsRSS.GetJsonRss("Customers");
            int numberOfCustomers = 0;
            var customers = from a in rss["value"]
                            select (string)a["Name"];
            foreach (var customer in customers)
            {
                numberOfCustomers++;
                TC.WriteLine("Customer Name: {0}", customer);
            }
            //assert
            Assert.IsTrue(numberOfCustomers > 0);
        }

        [TestMethod()]
        public void CreateSpecFlowExamples()
        {
            //arrange
            FinOpsRSS finOpsRSS = RSSUtil.CreateRssFromConfig();
            //act
            JObject rss = finOpsRSS.GetJsonRss("MainAccounts");
            int numberOfCustomers = 0;
            var customers = from a in rss["value"]
                            select (string)a["Name"];
            foreach (var customer in customers)
            {
                numberOfCustomers++;
                TC.WriteLine("\t| {0} |", customer);
            }
            //assert
            Assert.IsTrue(numberOfCustomers > 0);
        }

    }
}