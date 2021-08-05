<#

    .SYNOPSIS
    Update SQL database with results currently in Azure Storage Account

    .DESCRIPTION
    The PublishResultsDB.ps1 script provides you with automatically spinning up your Azure Contaniner Instance and 
    updating your database with new result files which have already been loaded into 
    the your Azure Storage Account.

    .PARAMETER SqlServerPresent
    This boolean flag confirms that the user has a SQL Server Database set up to proceed with publishing results to Power BI 

    .PARAMETER AzureContainerInstance
    The string name of the Azure Container Instance

    .PARAMETER ResourceGroup
    The string name of the resource group which the Azure Container Instance resides in 

    .INPUTS
    None.  You cannot pipe objects to PublishPreviousResults.ps1

    .EXAMPLE
    PS> .\PublishPreviousResults.ps1 -tenant jmeter -TestName ..\drparts.jmx -PublishPreviousResultsToStorageAccount ..\resultFile1.jtl, ..\resultFile2.jtl -PublishTestToStorageAccount -StorageAccount drpartsunlimited -Container jmeterresults

#>

#Requires -Version 7

param(
    [Parameter(Mandatory=$false)]
    [switch]
    $SqlServerPresent,
    [Parameter(Mandatory=$true)]
    [string]
    $AzureContainerInstance="",
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroup=""
)

Import-Module ./commenutils.psm1 -force

# Checking to make sure Azure Client is installed 
$isAzureClientInstalled=VerifyCommandExists -cmdName az
if ($isAzureClientInstalled)
{
        Write-Output "Azure Client found."
}
else
{
    Write-Output "Azure Client not found."
    throw "Azure Client is required to publish results to Azure Storage Account."
}

# Checking if SQL Server Database is present
if(!($SqlServerPresent.IsPresent))
{
    Write-Output "SQLServer Database not found."
    throw "SQLServer Database is required to publish results to Azure Storage Account."
}

# Checking if Azure Container Instance and Resource Group are present
if (($AzureContainerInstance -eq "") -and ($ResourceGroup -eq ""))
{
    Write-Output "Both Azure Container Instance and Resource Group must be specified if publishing results to Azure Storage Account."
    throw "Both Azure Container Instance and Resource Group are required."
}

# Starting Azure Instance 
Write-Output "Starting Azure Container Instance"
StartAzureContainerInstace -azureContainerInstance $AzureContainerInstance -resourceGroup $ResourceGroup


