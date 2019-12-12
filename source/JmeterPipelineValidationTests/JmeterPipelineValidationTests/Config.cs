using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace JmeterPipelineValidationTests
{
    public class Config
    {
        public static IConfiguration Configuration {
            get {
                var builder = new ConfigurationBuilder()
               .SetBasePath(Directory.GetCurrentDirectory())
               .AddJsonFile("apsettings.json");
                return builder.Build();
            }}

    }
}
