﻿using System;
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

        public static string ExtractTestPlan(string pathToJtlFile)
        {
            var splitPath = pathToJtlFile.Split("/");
            return splitPath[0];
        }
        public static string ExtractTestRun(string pathToJtlFile)
        {
            var splitPath = pathToJtlFile.Split("/");
            return splitPath[splitPath.Length - 2]; 
        }

        public CsvJtl(string pathToJtlFile = null)
        {
            if (!string.IsNullOrEmpty(pathToJtlFile))
            {
                testPlan = ExtractTestPlan(pathToJtlFile);
                testRun = ExtractTestRun(pathToJtlFile);
            }
            else
            {
                testPlan = "No Test Name";
            }
            this.pathToJtlFile = pathToJtlFile;

        }
        public CsvJtl(string pathToJtlFile,string testPlan,string testRun)
        {
            this.testPlan = testPlan;
            this.testRun = testRun;
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
            string responseMessage = jtlRow.responseMessage;
            jtlRowDict.Add("IsTransaction", IsTransaction(responseMessage));
            jtlRowDict.Add("TransactionSamples", ExtractTransactionSamples(responseMessage));
            jtlRowDict.Add("TransactionFailedSamples", ExtractTransactionFailedSamples(responseMessage));
            

        }
        private bool IsTransaction(string responseMessage)
        {
            if(responseMessage == null) return false;
            //Number of samples in transaction : 9, number of failing samples : 0
            if (responseMessage.StartsWith("Number of samples in transaction"))
            { return true; }
            return false;
        }
        private int ExtractTransactionSamples(string responseMessage)
        {
            if (responseMessage == null) return 0;
            //Number of samples in transaction : 9, number of failing samples : 0
            if (IsTransaction(responseMessage))
            {
                return int.Parse(responseMessage.Split(",")[0].Split(":")[1].Trim());
            }
            return 0;
        }
        private int ExtractTransactionFailedSamples(string responseMessage)
        {
            if (responseMessage == null) return 0;
            //Number of samples in transaction : 9, number of failing samples : 0
            if (IsTransaction(responseMessage))
            {
                return int.Parse(responseMessage.Split(",")[1].Split(":")[1].Trim());
            }
            return 0;
        }
        private DateTime ConvertJsonTimeStamp(long jsonTimeStamp)
        {
            DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return origin.AddMilliseconds(jsonTimeStamp);
        }
        public void Dispose()
        {
            if(jtlFileReader!=null)jtlFileReader.Dispose();
            jtlResultsReader.Dispose();
            
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
