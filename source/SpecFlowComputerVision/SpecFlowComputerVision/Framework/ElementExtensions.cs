using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Interactions;
using OpenQA.Selenium.Appium.Windows;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Remote;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;

namespace SpecFlowComputerVision.Framework
{
    public static class ElementExtensions
    {

        public static void DrawTriangle(WindowsDriver<WindowsElement> session)
        {
            OpenQA.Selenium.Appium.Interactions.PointerInputDevice penDevice = new OpenQA.Selenium.Appium.Interactions.PointerInputDevice(PointerKind.Pen);

            // Select the Brushes toolbox to have the Brushes Pane sidebar displayed and ensure that Marker is selected
            session.FindElementByAccessibilityId("Toolbox").FindElementByAccessibilityId("TopBar_ArtTools").Click();
            session.FindElementByAccessibilityId("SidebarWrapper").FindElementByAccessibilityId("PixelPencil3d").Click();

            // Locate the drawing surface
            WindowsElement inkCanvas = session.FindElementByAccessibilityId("InteractorFocusWrapper");

            Point canvasCoordinate = inkCanvas.Coordinates.LocationInViewport;
            Size squareSize = new Size(inkCanvas.Size.Width * 3 / 5, inkCanvas.Size.Height * 3 / 5);
            Point A = new Point(canvasCoordinate.X + inkCanvas.Size.Width / 5, canvasCoordinate.Y + inkCanvas.Size.Height / 5);
            TimeSpan howFast = TimeSpan.FromMilliseconds(500.0);

            ActionSequence sequence = new ActionSequence(penDevice, 0);

            var halfWidth = (inkCanvas.Size.Width / 2)+100;
            var halfHeight = (inkCanvas.Size.Height / 2)+500;

            // left base 
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth, halfHeight, TimeSpan.Zero));
            sequence.AddAction(penDevice.CreatePointerDown(PointerButton.TouchContact));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth - 1000, halfHeight, howFast));
            sequence.AddAction(penDevice.CreatePointerUp(PointerButton.PenContact));

            // right base 
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth, halfHeight, TimeSpan.Zero));
            sequence.AddAction(penDevice.CreatePointerDown(PointerButton.TouchContact));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth + 1000, halfHeight, howFast));
            //sequence.AddAction(penDevice.CreatePointerUp(PointerButton.PenContact));

            // right top 
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth + 1000, halfHeight, TimeSpan.Zero));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth, halfHeight - 1000, howFast));

            // left top 
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth, halfHeight - 1000, TimeSpan.Zero));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, halfWidth - 1000, halfHeight, howFast));


            session.PerformActions(new List<ActionSequence> { sequence });
        }

        public static void SelectTriangle(WindowsDriver<WindowsElement> session)
        {
            OpenQA.Selenium.Appium.Interactions.PointerInputDevice penDevice = new OpenQA.Selenium.Appium.Interactions.PointerInputDevice(PointerKind.Pen);

            // Select the Brushes toolbox to have the Brushes Pane sidebar displayed and ensure that Marker is selected
            session.FindElementByAccessibilityId("Toolbox").FindElementByAccessibilityId("TopBar_2DShapes").Click();
            session.FindElementByAccessibilityId("SidebarWrapper").FindElementByAccessibilityId("Sticker_RightTriangle").Click();

            // Locate the drawing surface
            WindowsElement inkCanvas = session.FindElementByAccessibilityId("InteractorFocusWrapper");
            inkCanvas.Click();

            // Change color of triangle
            session.FindElementByAccessibilityId("ShapeOutline").FindElementByAccessibilityId("ColorPickerCheckBox").Click();
            session.FindElementByAccessibilityId("#3f48cc").Click();
            
            // Change brush size
            session.FindElementByAccessibilityId("BrushSize").SendKeys("5");
            session.FindElementByAccessibilityId("BrushSize").SendKeys(Keys.Enter);

            inkCanvas.Click();


        }

        public static void DrawCircle(WindowsDriver<WindowsElement> session)
        {
            // Draw a circle with radius 300 and 40 (x, y) points
            const int radius = 300;
            const int points = 40;

            // Select the Brushes toolbox to have the Brushes Pane sidebar displayed and ensure that Marker is selected
            session.FindElementByAccessibilityId("Toolbox").FindElementByAccessibilityId("TopBar_ArtTools").Click();
            session.FindElementByAccessibilityId("SidebarWrapper").FindElementByAccessibilityId("Marker3d").Click();

            // Locate the drawing surface
            WindowsElement inkCanvas = session.FindElementByAccessibilityId("InteractorFocusWrapper");

            // Draw the circle with a single touch actions
            OpenQA.Selenium.Appium.Interactions.PointerInputDevice touchContact = new OpenQA.Selenium.Appium.Interactions.PointerInputDevice(PointerKind.Touch);
            ActionSequence touchSequence = new ActionSequence(touchContact, 0);
            touchSequence.AddAction(touchContact.CreatePointerMove(inkCanvas, 0, -radius, TimeSpan.Zero));
            touchSequence.AddAction(touchContact.CreatePointerDown(PointerButton.TouchContact));
            for (double angle = 0; angle <= 2 * Math.PI; angle += 2 * Math.PI / points)
            {
                touchSequence.AddAction(touchContact.CreatePointerMove(inkCanvas, (int)(Math.Sin(angle) * radius), -(int)(Math.Cos(angle) * radius), TimeSpan.Zero));
            }
            touchSequence.AddAction(touchContact.CreatePointerUp(PointerButton.TouchContact));
            session.PerformActions(new List<ActionSequence> { touchSequence });

            // Verify that the drawing operations took place
            WindowsElement undoButton = session.FindElementByAccessibilityId("UndoIcon");
        }

        public static void DrawRectangle(WindowsDriver<WindowsElement> session)
        {
            OpenQA.Selenium.Appium.Interactions.PointerInputDevice penDevice = new OpenQA.Selenium.Appium.Interactions.PointerInputDevice(PointerKind.Pen);

            // Select the Brushes toolbox to have the Brushes Pane sidebar displayed and ensure that Marker is selected
            session.FindElementByAccessibilityId("Toolbox").FindElementByAccessibilityId("TopBar_ArtTools").Click();
            session.FindElementByAccessibilityId("SidebarWrapper").FindElementByAccessibilityId("PixelPencil3d").Click();

            // Locate the drawing surface
            WindowsElement inkCanvas = session.FindElementByAccessibilityId("InteractorFocusWrapper");

            Point canvasCoordinate = inkCanvas.Coordinates.LocationInViewport;
            Size squareSize = new Size(inkCanvas.Size.Width * 3 / 5, inkCanvas.Size.Height * 3 / 5);
            Point A = new Point(canvasCoordinate.X + inkCanvas.Size.Width / 5, canvasCoordinate.Y + inkCanvas.Size.Height / 5);
            TimeSpan howFast = TimeSpan.FromMilliseconds(300.0);       

            ActionSequence sequence = new ActionSequence(penDevice, 0);

            // Draw line AB from point A to B
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, A.X, A.Y, TimeSpan.Zero));
            sequence.AddAction(penDevice.CreatePointerDown(PointerButton.PenContact));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, A.X + squareSize.Width, A.Y, howFast));
            sequence.AddAction(penDevice.CreatePointerUp(PointerButton.PenContact));

            // Draw line BC from point B to C
            sequence.AddAction(penDevice.CreatePointerDown(PointerButton.PenContact));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, A.X + squareSize.Width, A.Y + squareSize.Height, howFast));
            sequence.AddAction(penDevice.CreatePointerUp(PointerButton.PenContact));

            // Draw line CD from point C to D
            sequence.AddAction(penDevice.CreatePointerDown(PointerButton.PenContact));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, A.X, A.Y + squareSize.Height, howFast));
            sequence.AddAction(penDevice.CreatePointerUp(PointerButton.PenContact));

            // Draw line DA from point D to A
            sequence.AddAction(penDevice.CreatePointerDown(PointerButton.PenContact));
            sequence.AddAction(penDevice.CreatePointerMove(CoordinateOrigin.Viewport, A.X, A.Y, howFast));
            sequence.AddAction(penDevice.CreatePointerUp(PointerButton.PenContact));

            session.PerformActions(new List<ActionSequence> { sequence });
        }
    }
}
