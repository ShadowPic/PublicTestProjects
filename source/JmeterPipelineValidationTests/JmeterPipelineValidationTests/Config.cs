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
                string configFileContents = File.ReadAllText("appsettings.json");
                byte[] byteArray = Encoding.UTF8.GetBytes(configFileContents.Replace(@"\", @"\\"));
                MemoryStream stream = new MemoryStream(byteArray);
                var builder = new ConfigurationBuilder()
               .SetBasePath(Directory.GetCurrentDirectory())
               .AddJsonStream(stream);
                return builder.Build();
            }}

    }
}
