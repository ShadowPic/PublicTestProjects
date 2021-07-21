using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using CsvHelper;
namespace JtlToSql
{
    public class CsvJtl : IDisposable
    {
        StreamReader jtlFileReader;
        CsvReader jtlResultsReader = null;
        dynamic stashedFirstRow;
        bool firstLineRead = false;
        long firstJsonTimeStamp = 0;
        DateTime testStartTimeStamp;
        public DateTime TestStartTime
        {
            get { return testStartTimeStamp; }
        }
        string pathToJtlFile;
        string testPlan;
        public string TestPlan 
        { 
            get { return testPlan; } 
        }
        string testRun;
        public string TestRun
        {
            get { return testRun; }
        }
        public CsvJtl(string pathToJtlFile = null)
        {
            if (!string.IsNullOrEmpty(pathToJtlFile))
            {
                var splitPath = pathToJtlFile.Split("/");
                testPlan = splitPath[0];
                testRun = splitPath[splitPath.Length - 2];
            }
            else
            {
                testPlan = "No Test Name";
            }
            this.pathToJtlFile = pathToJtlFile;

        }

        void AddCalculatedColumns(dynamic jtlRow)
        {
            var jtlRowDict = jtlRow as IDictionary<string, object>;
            long currentTimeStamp = long.Parse(jtlRow.timeStamp);
            int elapsedMilliseconds = Convert.ToInt32(currentTimeStamp - firstJsonTimeStamp);
            jtlRowDict.Add("UtcTimeStamp", ConvertJsonTimeStamp(currentTimeStamp));
            jtlRowDict.Add("ElapsedMS", elapsedMilliseconds);
            jtlRowDict.Add("TestRun", this.testRun);
            jtlRowDict.Add("TestPlan", this.testPlan);
            jtlRowDict.Add("LabelPlusTestRun", $"{jtlRow.label} ({this.testRun})");
            jtlRowDict.Add("StorageAccountPath", pathToJtlFile);
        }

        private DateTime ConvertJsonTimeStamp(long jsonTimeStamp)
        {
            DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return origin.AddMilliseconds(jsonTimeStamp);
        }
        public void Dispose()
        {
            jtlResultsReader.Dispose();
            jtlFileReader.Dispose();
        }

        public dynamic GetCsvRow()
        {
            if (!firstLineRead)
            {
                firstLineRead = true;
                return stashedFirstRow;
            }
            dynamic csvRow = jtlResultsReader.GetRecord<dynamic>();
            AddCalculatedColumns(csvRow);
            return csvRow;
        }

        public void InitJtlReader(StreamReader jtlStream)
        {
            jtlResultsReader = new CsvReader(jtlStream, CultureInfo.InvariantCulture);
            jtlResultsReader.Read();
            jtlResultsReader.ReadHeader();
            jtlResultsReader.Read();
            stashedFirstRow = jtlResultsReader.GetRecord<dynamic>();
            firstJsonTimeStamp = long.Parse(stashedFirstRow.timeStamp);
            testStartTimeStamp = ConvertJsonTimeStamp(firstJsonTimeStamp);
            AddCalculatedColumns(stashedFirstRow);

        }
        public void InitJtlReader(string jtlFileName)
        {
            jtlFileReader = new StreamReader(jtlFileName);
            jtlResultsReader = new CsvReader(jtlFileReader, CultureInfo.InvariantCulture);
            jtlResultsReader.Read();
            jtlResultsReader.ReadHeader();
            jtlResultsReader.Read();
            stashedFirstRow = jtlResultsReader.GetRecord<dynamic>();
            firstJsonTimeStamp = long.Parse(stashedFirstRow.timeStamp);
            testStartTimeStamp = ConvertJsonTimeStamp(firstJsonTimeStamp);
            AddCalculatedColumns(stashedFirstRow);

        }
        public bool ReadNextCsvLine()
        {
            return jtlResultsReader.Read();
        }
    }
}
