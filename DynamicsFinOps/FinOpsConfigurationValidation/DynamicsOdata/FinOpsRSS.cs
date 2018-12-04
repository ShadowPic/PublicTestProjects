using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Net;

namespace DynamicsOdata
{
    public class FinOpsRSS
    {
        public string ActiveDirectoryTenant { get; set; }
        public string ActiveDirectoryResource { get; set; } 
        public string ActiveDirectoryClientAppId { get; set; }
        public string AzureSecret { get; set; }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="azureSecret"></param>
        /// <param name="axFinOpsUri"></param>
        /// <param name="clientAppId"></param>
        /// <param name="aDTenant"></param>
        public FinOpsRSS()
        {
            
        }
        public JObject GetJsonRss(string entity)
        {

            Uri odataEntityUri = new Uri(ActiveDirectoryResource).Combine("data", entity);
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(odataEntityUri);
            request.Method = "GET";
            AuthenticationContext authenticationContext = new AuthenticationContext(ActiveDirectoryTenant);
            var credential = new ClientCredential(ActiveDirectoryClientAppId, AzureSecret);
            AuthenticationResult authenticationResult = authenticationContext.AcquireTokenAsync(ActiveDirectoryResource, credential).Result;
            request.Headers["Authorization"] = authenticationResult.CreateAuthorizationHeader();
            JObject rss = null;
            using (var response = (HttpWebResponse)request.GetResponse())
            using (var stream = response.GetResponseStream())
            using (var sr = new StreamReader(stream))
            {
                rss = JObject.Parse(sr.ReadToEnd());

            }
            return rss;
        }
    }
}
