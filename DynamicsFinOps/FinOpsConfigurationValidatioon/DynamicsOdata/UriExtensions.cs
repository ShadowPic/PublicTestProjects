using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicsOdata
{
    public static class UriExtensions
    {
        public static Uri Combine(this Uri uriCurrent,params string[]  uriParts)
        {
            string uri = uriCurrent.ToString();
            if (uriParts != null && uriParts.Count() > 0)
            {
                char[] trims = new char[] { '\\', '/' };
                uri = (uri ?? string.Empty).TrimEnd(trims);
                for (int i = 0; i < uriParts.Count(); i++)
                {
                    uri = string.Format("{0}/{1}", uri.TrimEnd(trims), (uriParts[i] ?? string.Empty).TrimStart(trims));
                }
            }
            return new Uri( uri);

        }
    }
}
