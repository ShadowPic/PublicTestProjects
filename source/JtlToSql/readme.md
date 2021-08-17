# JtlToSql Solution
This solution adds functionality to allow for performance test results uploaded to an Azure Storage account to be imported into a SQL Database for reporting. The intention was to provide a more intuitive experience when users prefer to use PowerBi over Grafana for analyzing results.

The following assumptions are made:
- JMeter test results are present in a known storage account blob container assumed to be named **jmeterresults**.  
- The path to the results.jtl file relies on 

 ## JtlCsvToSqlAci.psi

The JtlCsvToSqlAci.psi script provides a highly flexible azure CLI command to 
create an [Azure container instance](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart#create-a-container) 

### Creating the Azure Container Instance:

Execute the following PowerShell
**JtlCsvToSqlAci.ps1**
- -JtlReportingDatabase(required): SQL Server Database connection string, this database is storing results files from the test runs 
- -JtlReportingStorage(required): Storage account where the results.jtl blob files can be found and are assumed to be in the jmeterresults blob container
- -ResourceGroup(required): Resource group for the ACI instance
- -ContainerName(required): Name of container

## FileToSql
NetCore 3.1 console application responsible for finding new storage account blobs and populating the SQL reporting database.  Currently it only looks at blobs that end with results.jtl to populate the SQL reporting db.

- This is intended to be hosted inside a Linux based Kubernetes pod.
- The only time this console application will look for new reports is when the service is restarted
  - Kubernetes pods are intended to be deleted all the time.
  - In the near future we intend to add the ability for the run test script to delete the current pod which will trigger a restart

Optional Parameters:

In the case you have updated your results.jtl or you need to remove the test plan stored in the SQL
databse, you are able to delete the test run stored in your SQL database. You need to specify 2 required parameters:

- - TestPlan : Root folder in the target container blob in the Azure Storage Account
- - TestRun : Parent folder of where results.jtl is stored

If both the test plan and test run are found, it is removed from the  SQL database and the program quits execution. 

## JmeterReportingDb
Database project containing the target schema and supporting stored procedures.

## JtlToSql
Common c# library which is specific to JtlToSql.  TODO:improve this documentation

## JtlToSqlTests
Unit test project for the JtlToSql library