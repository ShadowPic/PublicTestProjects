using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DynamicsOdata;
using System.Configuration;

namespace DynamicsOdataTests
{//apparently this is missing.
    public class RSSUtil
    {
        public static FinOpsRSS CreateRssFromConfig()
        {
            return new FinOpsRSS()
            {
#pragma warning disable CS0618 // Type or member is obsolete

                ActiveDirectoryTenant = ConfigurationSettings.AppSettings["ActiveDirectoryTenant"].ToString(),
                ActiveDirectoryResource = ConfigurationSettings.AppSettings["ActiveDirectoryResource"].ToString(),
                ActiveDirectoryClientAppId = ConfigurationSettings.AppSettings["ActiveDirectoryClientAppId"].ToString(),
                AzureSecret = ConfigurationSettings.AppSettings["AzureSecret"].ToString()
#pragma warning disable CS0618 // Type or member is obsolete

            };
        }
    }
}
