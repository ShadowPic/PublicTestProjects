// See https://aka.ms/new-console-template for more information
using Microsoft.Extensions.Logging;
using CommandLine;
using System;
using JtlToSqlDirectPublish;
using Microsoft.Extensions.Configuration;
using JtlToSql;

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
    IConfigurationRoot configuration = new ConfigurationBuilder()
        .AddJsonFile("secrets.json")
        .Build();
    var sqlConnectionString = opts.SqlConnectionString == null ? configuration["ConnectionStrings:JtlReportingDatabase"] : opts.SqlConnectionString;
    processJtlFiles.SendJtlToSQL(jtlFilePath, sqlConnectionString, testPlan, testRun);
    processJtlFiles.PostProcess();
    // Call the stored procedure here
    
}

void HandleParseError(IEnumerable<Error> errs)
{
    // Handle errors here
}