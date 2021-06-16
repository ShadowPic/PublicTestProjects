using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
namespace JMeterTestsScript
{
    public class Csv2Redis
    {
        public static void ConvertToRedis(string csvFileName,string redisScriptFilename)
        {
            using TextReader textReader = File.OpenText(csvFileName);
            using TextWriter textWriter = File.AppendText(redisScriptFilename);
            string csvBaseName = Path.GetFileNameWithoutExtension(csvFileName);
            textWriter.WriteLine($"del {csvBaseName}");
            string line = null;
            string csvHeader = textReader.ReadLine();
            while (textReader.Peek() > 0)
            {
                line = textReader.ReadLine();
                textWriter.WriteLine($"SADD {csvBaseName} \"{line}\"");
            }
        }
    }
}
