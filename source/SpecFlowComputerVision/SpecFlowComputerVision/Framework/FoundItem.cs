using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenCvSharp;

namespace SpecFlowComputerVision.Framework
{
    public class FoundItem
    {
        public Point[] Arc { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }

    }
}
