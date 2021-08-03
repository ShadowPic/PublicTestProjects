# JtlToSql Solution
This solution adds functionality to allow for performance test results uploaded to an Azure Storage account to be imported into a SQL Database for reporting. The intention was to provide a more intuitive experience when users prefer to use PowerBi over Grafana for analyzing results.

The following assumptions are made:
- JMeter test results are present in a known storage account blob container assumed to be named **jmeterresults**.  
- The path to the results.jtl file relies on 

## FileToSql
NetCore 3.1 console application responsible for finding new storage account blobs and populating the SQL reporting database.  Currently it only looks at blobs that end with results.jtl to populate the SQL reporting db.

- This is intended to be hosted inside a Linux based Kubernetes pod.
- The only time this console application will look for new reports is when the service is restarted
  - Kubernetes pods are intended to be deleted all the time.
  - In the near future we intend to add the ability for the run test script to delete the current pod which will trigger a restart


## JmeterReportingDb
Database project containing the target schema and supporting stored procedures.

## JtlToSql
Common c# library which is specific to JtlToSql.  TODO:improve this documentation

## JtlToSqlTests
Unit test project for the JtlToSql library