using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using CsvHelper;
namespace JtlToSql
{
    public class CsvJtl : IDisposable, ICsvJtl
    {
        CsvReader jtlResultsReader = null;
        bool firstLineRead = false;
        long firstJsonTimeStamp = 0;
        DateTime testStartTimeStamp;
        string pathToJtlFile;
        string testName;
        string testRun;
        public CsvJtl(string pathToJtlFile = null)
        {
            if (!string.IsNullOrEmpty(pathToJtlFile))
            {
                var splitPath = pathToJtlFile.Split("/");
                testName = splitPath[0];
                testRun = splitPath[splitPath.Length-2];
            }
            else
            {
                testName = "No Test Name";
            }
            this.pathToJtlFile = pathToJtlFile;
            
        }

        public void AddCalculatedColumns(dynamic jtlRow)
        {
            var jtlRowDict = jtlRow as IDictionary<string, object>;
            long currentTimeStamp = long.Parse(jtlRow.timeStamp);
            int elapsedMilliseconds =Convert.ToInt32( currentTimeStamp - firstJsonTimeStamp);
            jtlRowDict.Add("UtcTimeStamp", ConvertJsonTimeStamp(currentTimeStamp));
            jtlRowDict.Add("ElapsedMS", elapsedMilliseconds);
            jtlRowDict.Add("TestRun", this.testRun);
            jtlRowDict.Add("TestPlan", this.testName);
            jtlRowDict.Add("LabelPlusTestRun", $"{jtlRow.label} ({this.testRun})");
        }

        private DateTime ConvertJsonTimeStamp(long jsonTimeStamp)
        {
            DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return origin.AddMilliseconds(jsonTimeStamp);
        }
        public void Dispose()
        {
            jtlResultsReader.Dispose();
        }

        public dynamic GetCsvRow()
        {
            if(!firstLineRead)
            {
                dynamic firstRow = jtlResultsReader.GetRecord<dynamic>();
                firstJsonTimeStamp = long.Parse(firstRow.timeStamp);
                testStartTimeStamp = ConvertJsonTimeStamp(firstJsonTimeStamp);
                firstLineRead = true;
                return firstRow;
            }
            return jtlResultsReader.GetRecord<dynamic>();
        }

        public void InitJtlReader(StreamReader jtlStream)
        {
            jtlResultsReader = new CsvReader(jtlStream, CultureInfo.InvariantCulture);
            jtlResultsReader.Read();
            jtlResultsReader.ReadHeader();

        }

        public bool ReadNextCsvLine()
        {
            return jtlResultsReader.Read();
        }
    }
}
