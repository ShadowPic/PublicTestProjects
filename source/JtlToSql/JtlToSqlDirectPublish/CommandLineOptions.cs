using CommandLine;

namespace JtlToSqlDirectPublish
{
    public class CommandLineOptions
    {
        [Option('j', "jtl", Required = true, HelpText = "Path to the JTL file to process")]
        public string JtlFilePath { get; set; }

        [Option('c', "connectionstring", Required = true, HelpText = "Connection string to the SQL Server database")]
        public string SqlConnectionString { get; set; }

        [Option('p', "plan", Required = true, HelpText = "Test plan name")]
        public string TestPlan { get; set; }

        [Option('r', "run", Required = true, HelpText = "Test run name")]
        public string TestRun { get; set; }
    }
}
