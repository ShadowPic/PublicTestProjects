// See https://aka.ms/new-console-template for more information
using Microsoft.Extensions.Logging;
using CommandLine;
using System;
using JtlToSqlDirectPublish;
using Microsoft.Extensions.Configuration;
using JtlToSql;
using System.IO;

using ILoggerFactory loggerFactory = LoggerFactory.Create(builder =>
{
    builder.AddConsole();
});
ILogger logger = loggerFactory.CreateLogger<Program>();

logger.LogInformation("Hello World! Logging is {Description}.", "fun");

Parser.Default.ParseArguments<CommandLineOptions>(args)
    .WithParsed<CommandLineOptions>(opts => RunOptionsAndReturnExitCode(opts))
    .WithNotParsed<CommandLineOptions>((errs) => HandleParseError(errs));

void RunOptionsAndReturnExitCode(CommandLineOptions opts)
{
    var testPlan = opts.TestPlan;
    var testRun = opts.TestRun;
    var processJtlFiles = new ProcessJtlFiles();
    string jtlFilePath = opts.JtlFilePath;
    string sqlConnectionString = opts.SqlConnectionString;
    if (File.Exists("secrets.json"))
    {
        IConfigurationRoot configuration = new ConfigurationBuilder()
        .AddJsonFile("secrets.json")
        .Build();
        sqlConnectionString = configuration["ConnectionStrings:JtlReportingDatabase"];
    }

    processJtlFiles.SendJtlToSQL(jtlFilePath, sqlConnectionString, testPlan, testRun);
    // Call the stored procedure here

}

void HandleParseError(IEnumerable<Error> errs)
{
    logger.LogError("Error parsing command line arguments");
}