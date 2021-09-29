# Microsoft SQL Server Database Reporting 

In order to send data to PowerBI, your results are retrieved from your SQL Server Database. 

After results are uploaded to your Azure Storage account, you must start your ACI Container Instance. Once starting your ACI, your new results files are uploaded to your SQL Server Database. These results are can be viewed in your PowerBI report after refreshing your report. 

There are 4 steps when viewing result file data in PowerBI. 
- Uploading Previous Results Files 
    - 1. [Upload previous results to storage account ](StorageTechnologies.md)
    - 2. ACI Instance is started 
    - 3. New results files are uploaded to SQL database
    - 4. Result file data is displyaed in Power BI 
- Uploading New Result Files
    - 1. [Run new test and upload results to storage account ](readme.md)
    - 2. ACI Instance is started 
    - 3. New results files are uploaded to SQL database
    - 4. Result file data is displyaed in Power BI 


## Updating SQL Database
**File Name:** UpdateSqlReporting.ps1 

**This script has extended help documentation available.**  ps> get-help .\UpdateSqlReporting.ps1 -detailed

This script allows you to update your SQL database with new reports and/or removing reports using your ACI Instance. 

- -ACIInstance (required): Name of your Azure Container Instance
- -ResourceGroup (required): Name of your resource group where your ACI resides
- -Delete (optional): To allow for the ability remove reports from your database you can add this parameter to specify you will be updating your database by removing a report
- -TestPlan (optional): Name of the test plan to remove from the database
- -TestRun (optional): Name of the test run to remove from the database

If new reports have been uploaded to the Azure Storage Account, this script must be executed to update your SQL Server Database. It will pick up on newly uploaded reports and ignore reports which are already in the database.

If you need to update/delete a report currently in the database, you must specify the -Delete parameter and specify the appropriate test plan and test run to remove. 

