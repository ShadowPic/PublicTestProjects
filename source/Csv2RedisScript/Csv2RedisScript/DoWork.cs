using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using JMeterTestsScript;
using System.IO;
using CommandLine;

namespace Csv2RedisScript
{

    public class DoWork
    {
        public class Options
        {
            [Option('t', "testscript", Required = true, HelpText = "Your jmeter script containing csv config elements")]
            public string TestScript { get; set; }
            [Option("AddBackEndListener", Default = false,HelpText ="Whether or not to add influx db backend listener",Required =false)]
            public bool AddBackEndListener { get; set; }
            [Option("ContinueOnError", Default = true, HelpText = "It will attempt to continue even if some of the CSV Configs are missing elements", Required = false)]

            public bool ContinueOnError { get; set; }
        }

        static ILog Logger = LoggerHelper.GetXmlLogger(typeof(DoWork));
        public static string logFileName;

        public static void Run(string[] args)
        {
            Logger.Info("Csv2Redis Console starting execution");
            while (true)
            {
                Logger.Info("Checking Arguments");

                CommandLine.Parser.Default.ParseArguments<Options>(args)
                    .WithParsed(RunOptions)
                    .WithNotParsed(HandleParseError);

                Logger.Info("Csv2Redis Console ending execution");
                break;
            }
        }

        static void RunOptions(Options opts)
        {
            string testScript = Path.GetFileName( opts.TestScript);
            var workingDir = Path.GetDirectoryName(opts.TestScript);
            Directory.SetCurrentDirectory(workingDir);            
            string testScriptNew = Path.GetFileNameWithoutExtension(testScript) + "-modified.jmx";
            Logger.Info($"Opening {testScript}");
            JmeterScript jmeterScript = new JmeterScript(testScript, Logger);
            if (opts.AddBackEndListener)
            {
                Logger.Info("Adding Influx DB backend listener.");
                jmeterScript.AddBackEndListener();
            }
            Logger.Info("Checking for CSV config elements");
            if (jmeterScript.HasEnabledCsvControl())
            {
                Logger.Info("Starting to process the Csv Configs");
                jmeterScript.AddRedisControl(opts.ContinueOnError);
                jmeterScript.WriteNewFile(testScriptNew);
            }
        }
        static void HandleParseError(IEnumerable<Error> errs)
        {
            string eol = Environment.NewLine;
            string messageFormat = $"This application will analyze a jmeter test file and replace csv configuration " +
                $"elements with Redis Configuration elements in preparation for running the test on a test rig.  The only command line" +
                $"that it supports is --testscript YourJmeterTest.jmx \r\n" +
                $"The application will then generate 2 files:\r\n" +
                $"- YourJmeterTest-modified.jmx\r\n" +
                $"- csv2redis.redis";
            Console.WriteLine(messageFormat);
        }
    }
}
