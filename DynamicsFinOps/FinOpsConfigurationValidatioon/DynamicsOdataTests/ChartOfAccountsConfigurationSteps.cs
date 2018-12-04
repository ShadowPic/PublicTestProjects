using System;
using TechTalk.SpecFlow;
using Newtonsoft.Json.Linq;
using System.Linq;
using TechTalk.SpecFlow;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DynamicsOdata;
using System.Configuration;
namespace DynamicsOdataTests
{
    [Binding]
    public class ChartOfAccountsConfigurationSteps
    {
        [Given(@"the '(.*)' have been created")]
        public void GivenTheHaveBeenCreated(string p0)
        {
            JObject rss = null;
            if (!FeatureContext.Current.Keys.Contains(ScenarioContext.Current.ScenarioInfo.Title + "rss"))
            {
                FinOpsRSS finOpsRSS = RSSUtil.CreateRssFromConfig();
                rss = finOpsRSS.GetJsonRss(p0);
                FeatureContext.Current.Add(ScenarioContext.Current.ScenarioInfo.Title + "rss", rss);
            }
        }
        
        [When(@"we look at the '(.*)' key")]
        public void WhenWeLookAtTheKey(string p0)
        {
            if (!FeatureContext.Current.Keys.Contains(ScenarioContext.Current.ScenarioInfo.Title + "rssTag"))
                FeatureContext.Current.Add(ScenarioContext.Current.ScenarioInfo.Title + "rssTag", p0);


        }

        [Then(@"(.*) should match")]
        public void ThenShouldMatch(string p0)
        {
            string rssTag =(string) FeatureContext.Current[ScenarioContext.Current.ScenarioInfo.Title + "rssTag"];
            var rss = (JObject)FeatureContext.Current[ScenarioContext.Current.ScenarioInfo.Title + "rss"];
            var rssResults = from a in rss["value"]
                             where ((string)a[rssTag] == p0)
                             select (string)a[rssTag];
            Assert.IsTrue(rssResults.Count() > 0);
        }
    }
}
