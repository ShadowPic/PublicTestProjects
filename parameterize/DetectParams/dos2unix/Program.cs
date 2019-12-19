using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace dos2unix
{
    class Program
    {
        static void Main(string[] args)
        {
            string fileName = args[0];
            string fileContents = File.ReadAllText(fileName);
            File.WriteAllText(fileName,fileContents.Replace("\r\n", "\n"));
           
        }
        
    }
}
