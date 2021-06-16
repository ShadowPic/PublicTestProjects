using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using JMeterTestsScript;
using System.IO;


namespace Csv2RedisScript
{

    public class DoWork
    {
        ILog Logger = LoggerHelper.GetXmlLogger(typeof(DoWork));
        public static string testStatus = "Fail";
        public static string logFileName;
        public const string Passed = "Pass";
        public const string Failed = "Fail";

        public static void Run(string[] args)
        {
            ILog logger = LoggerHelper.GetXmlLogger(typeof(DoWork));

            logger.Info("Csv2Redis Console starting execution");
            while (true)
            {
                logger.Info("Checking Arguments");
                if (ArgsNotValid(args))
                {
                    logger.Warn("Arguments are not valid");
                    ShowUsage();
                    testStatus = "Fail";
                    throw new ArgumentException("invalid arguments");
                }
                string combined = null;

                foreach (string arg in args)
                {
                    combined += arg.ToLower(CultureInfo.CurrentCulture) + " ";
                }
                var argumentGroups = combined.Split("--");
                string testScript = argumentGroups.FirstOrDefault(a => a.Split(" ")[0] == "testscript").Split(" ")[1];
                string testScriptNew = Path.GetFileNameWithoutExtension(testScript) + "-modified.jmx";
                logger.Info($"Opening {testScript}");
                JmeterScript jmeterScript = new JmeterScript(testScript,logger);
                logger.Info("Checking for CSV config elements");
                if(jmeterScript.HasEnabledCsvControl())
                {
                    logger.Info("Starting to process the Csv Configs");
                    jmeterScript.AddRedisControl();
                    jmeterScript.WriteNewFile(testScriptNew); 
                }
                logger.Info("Csv2Redis Console ending execution");
                break;
            }
        }

        private static void ShowUsage()
        {
            string eol = Environment.NewLine;
            string messageFormat = "show parameters help";
            Console.WriteLine(messageFormat);
        }

        private static bool ArgsNotValid(string[] args)
        {
            if (args == null || args.Length < 2 || !args[0].StartsWith("--"))
            {
                return true;
            }

            return false;
        }

    }
}
