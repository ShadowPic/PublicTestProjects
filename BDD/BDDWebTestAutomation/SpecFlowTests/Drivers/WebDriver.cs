using System;
using System.Configuration;
using System.Diagnostics;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Support.UI;

namespace SpecFlowTests.Drivers
{
    public static class WebDriverExtensions
    {
        public static IWebElement FindElement(this IWebDriver driver, By by, int timeoutInSeconds)
        {
            if (timeoutInSeconds > 0)
            {
                var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(timeoutInSeconds));
                return wait.Until(drv => drv.FindElement(by));
            }
            return driver.FindElement(by);
        }
    }
    public class WebDriver : IDisposable
    {
        private IWebDriver _currentWebDriver;
        public WebDriver(string url)
        {
            this.SeleniumBaseUrl = url;
        }

        public WebDriver()
        {
            SeleniumBaseUrl = SpecFlowTests.Properties.Settings.Default.seleniumBaseUrl;
        }

        public Screenshot GetScreenShot()
        {
            return ((ITakesScreenshot)this.Current).GetScreenshot();
        }

        public void SetRelativeUrl(string relativeUrl)
        {
            this.Current.Url = this.SeleniumBaseUrl + relativeUrl;
        }
        public IWebDriver Current
        {
            get
            {
                if (_currentWebDriver != null)
                    return _currentWebDriver;

                switch (BrowserConfig.ToUpper())
                {
                    case "IE":
                        _currentWebDriver = new InternetExplorerDriver(new InternetExplorerOptions() { IgnoreZoomLevel = true}) { Url = SeleniumBaseUrl };
                        break;
                    case "CHROME":
                        _currentWebDriver = new ChromeDriver() { Url = SeleniumBaseUrl };
                        break;
                    case "FIREFOX":
                        _currentWebDriver = new FirefoxDriver() { Url = SeleniumBaseUrl };
                        break;
                    default:
                        throw new NotSupportedException($"{BrowserConfig} is not a supported browser");
                }

                return _currentWebDriver;
            }
        }

        private WebDriverWait _wait;
        public WebDriverWait Wait
        {
            get
            {
                if (_wait == null)
                {
                    this._wait = new WebDriverWait(Current, TimeSpan.FromSeconds(10));
                }
                return _wait;
            }
        }

        protected string BrowserConfig => SpecFlowTests.Properties.Settings.Default.BrowserConfig;
        public string SeleniumBaseUrl;

        public void Quit()
        {
            _currentWebDriver?.Quit();
        }

        public void Dispose()
        {
            _currentWebDriver?.Dispose();
            KillSelenium();

        }
        private void KillSelenium()
        {
            string nameOfDriver;
            string nameOfBrowser;
            try
            {
                switch (BrowserConfig)
                {
                    case "IE":
                        nameOfBrowser = "ie.exe";
                        nameOfDriver = "IEDriverServer";
                        break;
                    case "Chrome":
                        nameOfDriver = "chromedriver.exe";
                        nameOfBrowser = "chrome.exe";
                        break;
                    case "Firefox":
                        nameOfBrowser = "firefox.exe";
                        nameOfDriver = "geckodriver.exe";
                        break;
                    default:
                        throw new NotSupportedException($"{BrowserConfig} is not a supported browser");
                }

                var webDrivers = Process.GetProcessesByName(nameOfDriver);
                foreach (var webDriver in webDrivers)
                {
                    webDriver.Kill();
                }
                var browsers = Process.GetProcessesByName(nameOfBrowser);
                foreach (var browser in browsers)
                {
                    browser.Kill();
                }

            }
            catch
            {


            }
        }
    }
}
