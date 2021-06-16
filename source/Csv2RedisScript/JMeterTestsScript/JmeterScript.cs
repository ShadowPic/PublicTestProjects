using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace JMeterTestsScript
{
    public class JmeterScript
    {
        private string jmeterScriptFileName;
        XElement jmeterScriptXml;
        
        public JmeterScript()
        {

        }

        public JmeterScript(string jmeterScriptFileName)
        {
            this.jmeterScriptFileName = jmeterScriptFileName;
            jmeterScriptXml=XElement.Load(jmeterScriptFileName);
        }

        public void WriteNewFile(string jmeterDestinationFileName)
        {
            jmeterScriptXml.Save(jmeterDestinationFileName);
        }

        public bool HasEnabledCsvControl()
        {
            var foo = jmeterScriptXml.Descendants("CSVDataSet")
                .Where(item => (bool)item.Attribute("enabled"));
            return foo.Count() >0;
        }

        public void AddRedisControl()
        {
            var enabledCsvConfigElements = jmeterScriptXml.Descendants("CSVDataSet")
                .Where(item => (bool)item.Attribute("enabled"));
            foreach (var csvElement in enabledCsvConfigElements)
            {
                XElement redisConfigElement = XElement.Parse(JMeterTestsScript.Properties.Resources.redisConfigString);
                csvElement.Attribute("enabled").SetValue(false);
                redisConfigElement.Attribute("testname").SetValue(csvElement.Attribute("testname").Value);
                csvElement.AddAfterSelf(redisConfigElement);
                csvElement.AddAfterSelf(new XElement("hashTree"));
            }
            //jmeterScriptXml.Element("hashTree").Element("hashTree").Add(xElement);
        }
    }
}
