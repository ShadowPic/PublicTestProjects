using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowComputerVision
{
    public static class SystemDiagnosticsUtils
    {
        public static bool ProcessIsRunning(string appName)
        {
            var listOfApps = Process.GetProcessesByName(appName);
            return listOfApps.Length > 0;

        }
    }
}
