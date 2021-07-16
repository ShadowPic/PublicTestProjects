using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Microsoft.JtlToSqlFunction
{
    public static class JtlBlobTrigger
    {
        [FunctionName("JtlBlobTrigger")]
        public static void Run(
            [BlobTrigger("jmeterresults/{name}", Connection = "blobConnection")]Stream myBlob,
            string name,
            ILogger log)
        {
            var connStr = Environment.GetEnvironmentVariable("SQLConnectionString");
            if (!name.EndsWith("results.jtl"))
            {
                return;
            }
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
        }
    }
}
