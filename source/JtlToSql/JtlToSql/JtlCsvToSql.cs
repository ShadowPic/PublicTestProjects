using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Dynamic;

namespace JtlToSql
{
    public class JtlCsvToSql : IDisposable
    {
        string connectionString;
        SqlConnection sqlConnection;
        DataTable batchOfRows;
        string batchTableName = "jtlbatchrows";
        public JtlCsvToSql(string connectionString)
        {
            this.connectionString = connectionString;
            this.sqlConnection = new SqlConnection(connectionString);
            this.sqlConnection.Open();
            InitializeBatchOfRows();
        }

        private void InitializeBatchOfRows()
        {
            batchOfRows = new DataTable(batchTableName);
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "timeStamp", DataType = Type.GetType("System.Int64") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "elapsed", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength = 500, ColumnName = "label", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "responseCode", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=50, ColumnName = "responseMessage", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=200, ColumnName = "threadName", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "dataType", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=500, ColumnName = "failureMessage", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "success", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "bytes", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "sentBytes", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "grpThreads", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "allThreads", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=500, ColumnName = "URL", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "Latency", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "IdleTime", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "UtcTimeStamp", DataType = Type.GetType("System.DateTime") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "ElapsedMS", DataType = Type.GetType("System.Int32") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=100, ColumnName = "TestRun", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=500, ColumnName = "TestPlan", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { MaxLength=500, ColumnName = "LabelPlusTestRun", DataType = Type.GetType("System.String") });
            batchOfRows.Columns.Add(new DataColumn() { ColumnName = "Connect", DataType = Type.GetType("System.Int32") });

        }

        public void Dispose()
        {
            sqlConnection.Close();
            sqlConnection.Dispose();
            batchOfRows.Dispose();
        }

        public void AddJtlRow(dynamic csvRow)
        {
            //batchOfRows.Rows.Add(csvRow);
            DataRow dataRow = batchOfRows.NewRow();
            dataRow["timeStamp"] = Int64.Parse(csvRow.timeStamp);
            dataRow["elapsed"] = Int32.Parse(csvRow.elapsed);
            dataRow["label"] = csvRow.label;
            int toss;
            dataRow["responseCode"] = Int32.TryParse(csvRow.responseCode, out toss) ? Int32.Parse(csvRow.responseCode) : -1;
            dataRow["threadName"] = csvRow.threadName;
            dataRow["dataType"] = csvRow.dataType;
            dataRow["success"] = csvRow.success;
            dataRow["failureMessage"] = csvRow.failureMessage;
            dataRow["bytes"] = Int32.Parse(csvRow.bytes);
            dataRow["sentBytes"] = Int32.Parse(csvRow.sentBytes);
            dataRow["grpThreads"] = Int32.Parse(csvRow.grpThreads);
            dataRow["allThreads"] = Int32.Parse(csvRow.allThreads);
            dataRow["URL"] = csvRow.URL;
            dataRow["Latency"] = Int32.Parse(csvRow.Latency);
            dataRow["IdleTime"] = Int32.Parse(csvRow.IdleTime);
            dataRow["UtcTimeStamp"] = csvRow.UtcTimeStamp;
            dataRow["ElapsedMS"] = Convert.ToInt32(csvRow.ElapsedMS);
            dataRow["TestRun"] = csvRow.TestRun;
            dataRow["TestPlan"] = csvRow.TestPlan;
            dataRow["LabelPlusTestRun"] = csvRow.LabelPlusTestRun;
            dataRow["Connect"] = Int32.Parse(csvRow.Connect);
            batchOfRows.Rows.Add(dataRow);
            
        }

        public void CommitBatch()
        {
            SqlBulkCopyOptions sqlBulkCopyOptions = new SqlBulkCopyOptions();

            using SqlBulkCopy bulkCopy = new SqlBulkCopy(this.sqlConnection);
            bulkCopy.DestinationTableName = "jmeterrawresults";
            bulkCopy.ColumnMappings.Add("timeStamp", "timeStamp");
            bulkCopy.ColumnMappings.Add("elapsed", "elapsed");
            bulkCopy.ColumnMappings.Add("label", "label");
            bulkCopy.ColumnMappings.Add("responseCode", "responseCode");
            bulkCopy.ColumnMappings.Add("responseMessage", "responseMessage");
            bulkCopy.ColumnMappings.Add("threadName", "threadName");
            bulkCopy.ColumnMappings.Add("dataType", "dataType");
            bulkCopy.ColumnMappings.Add("success", "success");
            bulkCopy.ColumnMappings.Add("failureMessage", "failureMessage");
            bulkCopy.ColumnMappings.Add("bytes", "bytes");
            bulkCopy.ColumnMappings.Add("sentBytes", "sentBytes");
            bulkCopy.ColumnMappings.Add("grpThreads", "grpThreads");
            bulkCopy.ColumnMappings.Add("allThreads", "allThreads");
            bulkCopy.ColumnMappings.Add("URL", "URL");
            bulkCopy.ColumnMappings.Add("Latency", "Latency");
            bulkCopy.ColumnMappings.Add("IdleTime", "IdleTime");
            bulkCopy.ColumnMappings.Add("Connect", "Connect");
            bulkCopy.ColumnMappings.Add("TestRun", "TestRun");
            bulkCopy.ColumnMappings.Add("TestPlan", "TestPlan");
            bulkCopy.ColumnMappings.Add("UtcTimeStamp", "UtcTimeStamp");
            bulkCopy.ColumnMappings.Add("ElapsedMS", "ElapsedMS");
            bulkCopy.ColumnMappings.Add("LabelPlusTestRun", "LabelPlusTestRun");

            bulkCopy.WriteToServer(batchOfRows);
            batchOfRows.Clear();
        }

        public static bool ReportAlreadyProcessed(string testPlan, string testRun,string connectionString)
        {
            using SqlConnection testRunsConnection = new SqlConnection(connectionString);
            testRunsConnection.Open();
            string query = $"select * from TestRuns where TestPlan='{testPlan}' and TestRun='{testRun}'";
            using SqlCommand checkForReport = new SqlCommand() {
                CommandText = query,
                Connection = testRunsConnection,
                CommandType = CommandType.Text
            };
            using var reader = checkForReport.ExecuteReader();
            bool hasRows = reader.HasRows;
            testRunsConnection.Close();
            return hasRows;
        }

        public void AddReport(string testPlan, string testRun, DateTime testStartTime)
        {
            CommitBatch();
            using SqlCommand spAddReport = new SqlCommand()
            {
                Connection = this.sqlConnection,
                CommandText = "spAddReport",
                CommandType = CommandType.StoredProcedure
            };
            spAddReport.Parameters.Add(new SqlParameter() { ParameterName = "@TestRun", DbType = DbType.String, Value = testRun });
            spAddReport.Parameters.Add(new SqlParameter() { ParameterName = "@TestPlan", DbType = DbType.String, Value = testPlan });
            spAddReport.Parameters.Add(new SqlParameter() { ParameterName = "@StartTime", DbType = DbType.DateTime, Value = testStartTime });
            spAddReport.ExecuteNonQuery();
        }
        public void DeleteReport(string testPlan, string testRun)
        {
            using SqlCommand spAddReport = new SqlCommand()
            {
                Connection = this.sqlConnection,
                CommandText = "spDeleteReport",
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 300
            };
            spAddReport.Parameters.Add(new SqlParameter() { ParameterName = "@TestRun", DbType = DbType.String, Value = testRun });
            spAddReport.Parameters.Add(new SqlParameter() { ParameterName = "@TestPlan", DbType = DbType.String, Value = testPlan });
            spAddReport.ExecuteNonQuery();
        }
    }
}
