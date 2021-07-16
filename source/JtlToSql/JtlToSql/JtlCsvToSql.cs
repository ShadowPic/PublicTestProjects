using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace JtlToSql
{
    public class JtlCsvToSql : IDisposable
    {
        string connectionString;
        SqlConnection sqlConnection;
        public JtlCsvToSql(string connectionString)
        {
            this.connectionString = connectionString;
            this.sqlConnection = new SqlConnection(connectionString);
            this.sqlConnection.Open();
        }



        public void Dispose()
        {
            sqlConnection.Close();
            sqlConnection.Dispose();
        }

        public void AddJtlRow(dynamic csvRow)
        {
            using SqlCommand spAddJtlRow = new SqlCommand()
            {
                Connection = this.sqlConnection,
                CommandText = "spAddJtlRow",
                CommandType = CommandType.StoredProcedure
            };
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@storageaccountpath", DbType = DbType.String, Value = csvRow.StorageAccountPath });
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@timeStamp", DbType = DbType.Int64, Value = csvRow.timeStamp});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@elapsed", DbType = DbType.Int32, Value = csvRow.elapsed});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@label", DbType = DbType.String, Value = csvRow.label});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@responseCode", DbType = DbType.Int32, Value = csvRow.responseCode});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@responseMessage", DbType = DbType.String, Value =csvRow.responseMessage });
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@threadName", DbType = DbType.String, Value = csvRow.threadName});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@dataType", DbType = DbType.String, Value = csvRow.dataType});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@success", DbType = DbType.String, Value = csvRow.success});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@failureMessage", DbType = DbType.String, Value = csvRow.failureMessage});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@bytes", DbType = DbType.Int32, Value = csvRow.bytes});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@sentBytes", DbType = DbType.Int32, Value = csvRow.sentBytes});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@grpThreads", DbType = DbType.Int32, Value = csvRow.grpThreads});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@allThreads", DbType = DbType.Int32, Value = csvRow.allThreads});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@URL", DbType = DbType.String, Value = csvRow.URL });
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@Latency", DbType = DbType.Int32, Value = csvRow.Latency});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@IdleTime", DbType = DbType.Int32, Value = csvRow.IdleTime});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@UtcTimeStamp", DbType = DbType.DateTime, Value = csvRow.UtcTimeStamp});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@ElapsedMS", DbType = DbType.Int32, Value=csvRow.ElapsedMS});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@TestRun", DbType = DbType.String, Value = csvRow.TestRun});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@TestPlan", DbType = DbType.String, Value = csvRow.TestPlan});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@LabelPlusTestRun", DbType = DbType.String, Value = csvRow.LabelPlusTestRun});
            spAddJtlRow.Parameters.Add(new SqlParameter() { ParameterName = "@Connect", DbType = DbType.Int32, Value = csvRow.Connect });

            spAddJtlRow.ExecuteNonQuery();
        }

    }
}
