using System;
using System.Drawing;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Appium.Windows;
using SpecFlowComputerVision.Framework;
using TechTalk.SpecFlow;

namespace SpecFlowComputerVision
{
    [Binding]
    public class PaintSteps
    {
        private PaintPomBase paintPomBase = null;
        private FoundItem[] itemsFound;

        [BeforeScenario()]
        public void  LaunchApplication(TestContext context)
        {
            paintPomBase = new PaintPomBase();
            paintPomBase.CreateNewPaint3DProject();
        }

        [AfterScenario()] 
        public void CleanUp()
        {
            paintPomBase.TearDown();
        }

        public PaintSteps()
        {
            paintPomBase = new PaintPomBase();
        }

        [Given(@"I draw a rectangle")]
        public void GivenIDrawARectangle()
        {
            paintPomBase.DrawRectangle();
        }

        [Given(@"I select a traingle")]
        public void GivenISelectATraingle()
        {
            paintPomBase.SelectTriangle();
        }

        [Then(@"image with (.*) sides is found")]
        public void ThenImageWithSidesIsFound(int sideNum)
        {
            WindowsElement inkCanvas = paintPomBase.GetCanvas();

            Screenshot screenShot = inkCanvas.GetScreenshot();
            using (var memoryStream = new MemoryStream(screenShot.AsByteArray))
            using (Bitmap bitmap = new Bitmap(memoryStream))
            {
                itemsFound = ImageObjectDetection.FindNSidedElement(bitmap, sideNum, false);
                Console.WriteLine($"itemsFound= {itemsFound.Length}");
                Assert.IsTrue(itemsFound.Length == 1);
            };
        }




    }
}
