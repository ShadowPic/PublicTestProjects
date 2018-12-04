using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DynamicsOdata;
using System.Configuration;

namespace DynamicsOdataTests
{
    public class RSSUtil
    {
        public static FinOpsRSS CreateRssFromConfig()
        {
            return new FinOpsRSS()
            {
                ActiveDirectoryTenant = ConfigurationSettings.AppSettings["ActiveDirectoryTenant"].ToString(),
                ActiveDirectoryResource = ConfigurationSettings.AppSettings["ActiveDirectoryResource"].ToString(),
                ActiveDirectoryClientAppId = ConfigurationSettings.AppSettings["ActiveDirectoryClientAppId"].ToString(),
                AzureSecret = ConfigurationSettings.AppSettings["axTestSecret"].ToString()
            };
        }
    }
}
