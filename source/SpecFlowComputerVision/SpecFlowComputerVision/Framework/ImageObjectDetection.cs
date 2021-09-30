using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenCvSharp;
using OpenCvSharp.Extensions;

namespace SpecFlowComputerVision.Framework
{
    class ImageObjectDetection
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="image"></param>
        /// <param name="sides"></param>
        /// <returns></returns>
        public static FoundItem[] FindNSidedElement(System.Drawing.Bitmap image, int sides, bool debugMode = false)
        {
            List<FoundItem> itemsFound = new List<FoundItem>();
            bool closed = false;

            using (Mat srcColor = image.ToMat())
            using (Mat mOutput = new Mat(srcColor.Rows, srcColor.Cols, MatType.CV_8UC4))
            using (var grey = srcColor.CvtColor(ColorConversionCodes.BGRA2GRAY))
            using (var blueMask = srcColor.InRange(new Scalar(204, 72, 63), new Scalar(204, 72, 63)))
            {
                //TODO:This may need to be refactored not sure if objects that need to be disposed are missing
                var src = grey.SetTo(new Scalar(0, 0, 0), blueMask);
                int maximumTargetWidth = (int)Math.Round(srcColor.Width * .9, 0);
                int overAllImageArcLength = src.Width * 2 + src.Height * 2;
                if (debugMode) Console.WriteLine($"overAllImageArcLength {overAllImageArcLength}");
                srcColor.CopyTo(mOutput);
                Cv2.FindContours(
                    image: src,
                    contours: out OpenCvSharp.Point[][] contours,
                    hierarchy: out HierarchyIndex[] outputArray,
                    mode: RetrievalModes.Tree,
                    method: ContourApproximationModes.ApproxTC89KCOS);

                for (int i = 0; i < contours.Length; i++)
                {
                    var mat = contours[i];
                    double distance = 0.01 * Cv2.ArcLength(mat, closed);
                    var approx = Cv2.ApproxPolyDP(mat, distance, closed);
                    double sidesLength = Cv2.ArcLength(approx, closed);

                    if (sidesLength > 1.0 && outputArray[i].Child == -1)
                    {
                        if (debugMode)
                        {
                            Console.WriteLine($"i: {i} mat.Length:{mat.Length} sidesLength: {sidesLength} mat length {Cv2.ArcLength(mat, closed)} distance {distance}");
                            Console.WriteLine($"outputArray[i].Child:{outputArray[i].Child} outputArray[i].Next:{outputArray[i].Next} outputArray[i].Parent:{outputArray[i].Parent}outputArray[i].Previous: {outputArray[i].Previous}");
                        }
                        string additionalDescriptor = "";
                        Scalar scalar = new Scalar();
                        scalar = Scalar.Red;
                        Rect rect = Cv2.BoundingRect(mat);
                        if (mat.Length == sides && rect.Width <= maximumTargetWidth)
                        {


                            itemsFound.Add(new FoundItem()
                            {
                                Arc = mat,
                                Width = rect.Width,
                                Height = rect.Height

                            });
                            additionalDescriptor = "Target";
                            scalar = Scalar.Pink;
                            if (debugMode) Console.WriteLine("Target Found");
                        }
                        if (debugMode)
                        {
                            Cv2.DrawContours(
                           mOutput,
                           contours,
                           contourIdx: i,
                           color: scalar,
                           thickness: 2,
                           lineType: LineTypes.Link8,
                           hierarchy: outputArray,
                           maxLevel: 0);
                            Point middle = new Point();
                            middle.X = mat[0].X + 10;
                            middle.Y = mat[0].Y + 30;
                            Cv2.PutText(mOutput, $"{i} {additionalDescriptor}", middle, HersheyFonts.HersheyPlain, 1.0, Scalar.Black, 2);
                        }
                    }
                }
                if (debugMode)
                {
                    srcColor.SaveImage(@"c:\drop\source.png");
                    mOutput.SaveImage(@"c:\drop\moutput.png");
                    src.SaveImage(@"c:\drop\greyscale.png");
                    using (new Window("Contour Source", srcColor))
                    using (new Window("Contours Found", mOutput))
                    using (new Window("Modified grey scale", src))
                        Cv2.WaitKey();
                }
                src.Dispose();
                return itemsFound.ToArray();
            }

        }
    }
}
