using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Interactions;
using OpenQA.Selenium.Appium.Windows;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Remote;
using SpecFlowComputerVision.Framework;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;

namespace SpecFlowComputerVision
{
    class PaintPomBase
    {
        // Note: append /wd/hub to the URL if you're directing the test at Appium
        public static WinAppDriverInstance WinAppDriverInstance = null;
        protected const string WindowsApplicationDriverUrl = "http://127.0.0.1:4723";
        private const string Paint3DAppId = @"Microsoft.MSPaint_8wekyb3d8bbwe!Microsoft.MSPaint";

        protected static WindowsDriver<WindowsElement> session;
        private WindowsElement inkCanvas;
        private WindowsElement undoButton;
        private WindowsElement brushesPane;
        private const string eraserWidth = "8";

        private static Point A = new Point(-298, -214);
        private static Point B = new Point(298, -298);
        private static Point C = new Point(298, 298);
        private static Point D = new Point(-298, 214);
        private static Point E = new Point(-38, 0);

        public PaintPomBase()
        {
            // launch WinAppDriver 
            if (WinAppDriverInstance == null)
            {
                WinAppDriverInstance = new WinAppDriverInstance();

            }

            // Launch Paint 3D application if it is not yet launched
            if (session == null)
            {
                // Create a new session to launch Paint 3D application

                AppiumOptions opt = new AppiumOptions();
                opt.AddAdditionalCapability("app", Paint3DAppId);
                opt.AddAdditionalCapability("deviceName", "WindowsPC");
                session = new WindowsDriver<WindowsElement>(new Uri(WindowsApplicationDriverUrl), opt);

                // Set implicit timeout to 1.5 seconds to make element search to retry every 500 ms for at most three times
                session.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(1.5);

                // Maximize Paint 3D window to ensure all controls being displayed
                session.Manage().Window.Maximize();
            }
        }

        public void TearDown()
        {
            // Close the application and delete the session
            if (session != null)
            {
                ClosePaint3D();
                session.Quit();
                session = null;
                WinAppDriverInstance.Dispose();
            }
        }

        public void CreateNewPaint3DProject()
        {
            try
            {
                session.FindElementByAccessibilityId("WelcomeScreenNewButton").Click();
                System.Threading.Thread.Sleep(TimeSpan.FromSeconds(1));
            }
            catch
            {
                // Create a new Paint 3D project by pressing Ctrl + N
                session.SwitchTo().Window(session.CurrentWindowHandle);
                session.Keyboard.SendKeys(Keys.Control + "n" + Keys.Control);
                System.Threading.Thread.Sleep(TimeSpan.FromSeconds(1));
                DismissSaveConfirmDialog();
            }
        }

        private static void DismissSaveConfirmDialog()
        {
            try
            {
                WindowsElement closeSaveConfirmDialog = session.FindElementByAccessibilityId("CloseSaveConfirmDialog");
                closeSaveConfirmDialog.FindElementByAccessibilityId("SecondaryBtnG3").Click();
            }
            catch { }
        }

        private static void ClosePaint3D()
        {
            try
            {
                session.Close();
                string currentHandle = session.CurrentWindowHandle; // This should throw if the window is closed successfully

                // When the Paint 3D window remains open because of save confirmation dialog, attempt to close modal dialog
                DismissSaveConfirmDialog();
            }
            catch { }
        }

        public WindowsElement GetCanvas()
        {
            WindowsElement inkCanvas = session.FindElementByAccessibilityId("InteractorFocusWrapper");

            return inkCanvas;
        }

        public void SelectTriangle()
        {
            ElementExtensions.SelectTriangle(session);
        }

        public void DrawRectangle()
        {
            ElementExtensions.DrawRectangle(session);
        }

    }
}
