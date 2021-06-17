using System;
using System.IO;
using log4net;

namespace Csv2RedisScript
{
    class Program
    {
        static void Main(string[] args)
        {
            DoWork.Run(args);
            
        }
    }
}
