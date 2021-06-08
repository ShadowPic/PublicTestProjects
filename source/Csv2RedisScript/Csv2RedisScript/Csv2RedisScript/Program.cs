using System;
using System.IO;

namespace Csv2RedisScript
{
    class Program
    {
        static void Main(string[] args)
        {
            string fileName = args[0];
            string csvBaseName = Path.GetFileNameWithoutExtension(fileName);
            string fileContents = File.ReadAllText(fileName);
            using TextReader textReader = File.OpenText(fileName);
            string line = null;
            string csvHeader = textReader.ReadLine();
            Console.WriteLine($"del {csvBaseName}");
            while ( textReader.Peek()>0)
            {
                line = textReader.ReadLine();
                Console.WriteLine($"SADD {csvBaseName} \"{line}\"");
            }
            
        }
    }
}
