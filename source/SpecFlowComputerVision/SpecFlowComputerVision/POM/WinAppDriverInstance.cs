using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowComputerVision
{
    public class WinAppDriverInstance : IDisposable
    {
        private Process _winappDriverInstance;
        public WinAppDriverInstance(string pathToWinAppDriver = @"C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe")
        {
            if (SystemDiagnosticsUtils.ProcessIsRunning("WinAppDriver"))
            {
                _winappDriverInstance = Process.GetProcessesByName("WinAppDriver")[0];
            }
            else
            {
                _winappDriverInstance = new Process();
                _winappDriverInstance.StartInfo.FileName = pathToWinAppDriver;
                _winappDriverInstance.StartInfo.UseShellExecute = true;
                bool itStarted = _winappDriverInstance.Start();
                if (!itStarted)
                {
                    throw new Exception("Failed to launch Winnappdriver");
                }
            }
        }
        public void Dispose()
        {

            _winappDriverInstance.Kill();
            _winappDriverInstance.Dispose();
        }
    }
}