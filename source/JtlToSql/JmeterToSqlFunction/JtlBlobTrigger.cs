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
        [return: Queue("JtlPendingReports",Connection = "blobConnection")]
        public static string Run(
            [BlobTrigger("jmeterresults/{name}", Connection = "blobConnection")] byte[] jtlContent,
            string name,
            ILogger log)
        {
            
            if (!name.EndsWith("results.jtl"))
            {
                return null;
            }
            else
            {
                return name;
            }
            
        }
    }
}
