using TechTalk.SpecFlow;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SpecFlowTests.Drivers;
using OpenQA.Selenium;

namespace SpecFlowTests
{
    [Binding]
    public class BDDCoffeeSiteSteps
    {
        public static WebDriver webDriver = null;
        [AfterTestRun]
        public static void AfterTestRun()
        {
            webDriver?.Quit();
            webDriver?.Dispose();
        }

        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            webDriver = new WebDriver();
        }
        [Given(@"I have a deployed web site")]
        public void GivenIHaveADeployedWebSite()
        {
            //ScenarioContext.Current.Pending();
        }
        
        [Given(@"I want to override the default site url")]
        public void GivenIWantToOverrideTheDefaultSiteUrl()
        {
            
        }
        
        [When(@"I set the Site Url to (.*)")]
        public void WhenISetTheSiteUrlToHttpsDrcoffee_Azurewebsites_Net(string p0)
        {
            webDriver.SeleniumBaseUrl = p0;
        }
        
        [Then(@"a browser opens to the default page")]
        public void ThenABrowserOpensToTheDefaultPage()
        {
            webDriver.Current.Navigate();
        }

        [Given(@"I like Capuccino")]
        public void GivenILikeCapuccino()
        {
            
        }

        [When(@"I go to the relative url of (.*)")]
        public void WhenIGoToTheRelativeUrlOf(string p0)
        {
            webDriver.SetRelativeUrl(p0);
            webDriver.Current.Navigate();
        }

        [Then(@"the coffee type (.*) is found")]
        public void ThenTheCoffeeTypeCappuccinoIsFound(string p0)
        {
            Assert.IsTrue(webDriver.Current.PageSource.Contains(p0));
        }

        [Then(@"I can verify the text '(.*)' is on the page")]
        public void ThenICanVerifyTheTextIsOnThePage(string p0)
        {
            Assert.IsTrue(webDriver.Current.PageSource.Contains(p0));
        }

        [Given(@"I want to show how to write tests")]
        public void GivenIWantToShowHowToWriteTests()
        {
           
        }

    }
}
