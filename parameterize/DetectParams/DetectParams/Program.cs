using System;
using System.Xml;
using System.IO;
using System.Xml.Linq;
using System.Linq;
using System.Linq.Expressions;
using System.Collections.Generic;
namespace DetectParams
{
    class Program
    {
        static void Main(string[] args)
        {
            string filename = "floodio.xml";
            string xmlString = File.ReadAllText(filename).Replace("\r\n", "\n");

            var xElement = XElement.Parse(xmlString);
            System.Collections.Generic.IEnumerable<object> items = from item in xElement.DescendantNodes()
                                                                   where item.ToString().Contains(@"amFwcG1DMFhKYk00aVFsZkJOZ1VCUT09LS1QUWlOaElaR1ltMG9NVkcvVlhQTWZ3PT0=--63516119f76973f97525468ca67c52f17b6ac394")
                                                                   select item;
             Console.WriteLine("Hello World!");
        }
    }
}
