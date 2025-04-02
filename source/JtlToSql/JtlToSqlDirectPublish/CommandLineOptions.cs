using CommandLine;

namespace JtlToSqlDirectPublish
{
    public class CommandLineOptions
    {
        [Option('j', "jtl", Required = true, HelpText = "Path to the JTL file to process")]
        public string JtlFilePath { get; set; }

        [Option('c', "connectionstring", Required = false, HelpText = "Connection string to the SQL Server database")]
        public string SqlConnectionString { get; set; }

        [Option('p', "plan", Required = true, HelpText = "Test plan name")]
        public string TestPlan { get; set; }

        [Option('r', "run", Required = true, HelpText = "Test run name")]
        public string TestRun { get; set; }

        [Option("is_test_of_record", Required = false, HelpText = "Is this the test of record")]
        public bool? IsTestOfRecord { get; set; }

        [Option("uses_thinktimes", Required = false, HelpText = "Does this test use think times")]
        public bool? UsesThinkTimes { get; set; }

        [Option("run_notes", Required = false, HelpText = "Notes about the run")]
        public string? RunNotes { get; set; }

        [Option("app_version_ref", Required = false, HelpText = "Reference to the application version")]
        public string? AppVersionRef { get; set; }
    }
}
