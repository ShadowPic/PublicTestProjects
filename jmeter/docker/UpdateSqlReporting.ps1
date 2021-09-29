<#
    .SYNOPSIS
    Update SQL Server Database with new reports or remove unnecessary reports 

    .DESCRIPTION
    The UpdateSqlReporting.ps1 script provides a highly flexible method to start your Azure Container Instance and update your SQL server database with new reports which have been uploaded to your Azure Storage Account. 
    You also have the ability to remove reports already in you SQL Server database by specifying which test plan and test run you would like to remove. 

    .PARAMETER ACIInstance
    Name of your Azure Container Instance

    .PARAMETER ResourceGroup
    Name of your resource group where your ACI resides

    .PARAMETER Delete
    To allow for the ability remove reports from your database you can add this parameter to specify you will be updating your database by removing a report

    .PARAMETER TestPlan
    Name of the test plan to remove from the database

    .PARAMETER TestRun
    Name of the test run to remove from the database

    .PARAMETER StorageAccountName
    The string name of the storage account which where your reports are stored
#>

param(
    [Parameter(Mandatory=$true)]
    [string]
    $ACIInstance="",
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroup="",
    [Parameter(Mandatory=$false)]
    [switch]
    $DeleteReport,
    [Parameter(Mandatory=$false)]
    [string]
    $TestPlan="",
    [Parameter(Mandatory=$false)]
    [string]
    $TestRun="",
    [Parameter(Mandatory=$false)]
    [string]
    $StorageAccountName="",
    [Parameter(Mandatory=$false)]
    [string]
    $Container="jmeterresults"
)

Import-Module ./commenutils.psm1 -force

if(($ACIInstance -eq "") -or ($ResourceGroup -eq ""))
{
        Write-Error "If updating reports in SQL Server database the -ACIInstance and -ResourceGroup are required fields"
        throw "Required fields missing when updating reports in the SQL Server Database"
}
Write-Output "Starting Azure Container Instance"
az container start --name $ACIInstance --resource-group $ResourceGroup

if ($DeleteReport.IsPresent)
{
    if(($TestPlan -eq "") -or ($TestRun -eq ""))
    {
        Write-Error "If removing report from SQL database, the -TestPlan and -TestRun are required fields"
        throw "Required fields missing when removing report in the SQL Server Database"
    }

    Write-Output "Starting to remove Test Plan $TestPlan Test Run $TestRun from Azure Storage Account"
    $AccountKey = RetrieveStorageAccountKey -StorageAccountName $StorageAccountName

    #Getting Directory Path from TestRun
    $year=$TestRun.Substring(0,4)
    $month=$TestRun.SubString(4,2)
    $day=$TestRun.Substring(6,2)
    $DirectoryPath="$TestPlan/$year/$month/$day/$TestRun*"
    RemoveResultsFromStorageAccount -Container $Container -StorageAccountName $StorageAccountName -AccountKey $AccountKey -DirectoryPath $DirectoryPath
    Write-Output "Finished removing Test Plan $TestPlan Test Run $TestRun from Azure Storage Account"

    Write-Output "Starting to remove Test Plan $TestPlan Test Run $TestRun from SQL Database"
    az container exec --name jtltosql --resource-group $ResourceGroup --exec-command "./FileJtlToSql --testplan $TestPlan --testrun $TestRun"
     Write-Output "Finished removing Test Plan $TestPlan Test Run $TestRun from SQL Database"
}
