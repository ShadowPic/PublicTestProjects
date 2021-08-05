<#
    .SYNOPSIS
    Publishes previous JMeter result files in Azure Blob Storage

    .DESCRIPTION
    The PublishPreviousResults.ps1 script provides a highly flexible method to publish local jtl file or modified result files to
    an already existing Azure Storage account. It will automatically conform to the reuqired naming convention so that you have the 
    ability to do more advanced reporting like with PowerBi. It will produce a uniquely named folder in the current working directory. 

    .PARAMETER Tenant
    Theoretically this allows for multiple concurrent jmeter deployments on a common AKS cluster.  Please note
    that this feature has not been functionally tested yet.

    .PARAMETER TestName
    The name of the JMeter test to be executed.

    .PARAMETER $PublishPreviousResultsToStorageAccount
    The string name of the file that you are uploading to the Azure Storage account

    .PARAMETER $$PublishTestToStorageAccount
    This feature gives you the option to upload the JMeter test to the Azure Storage account and in the uniquly created report folder 

    .PARAMETER StorageAccount
    The string name for the storage account you are uploading the results folder to

    .PARAMETER Container
    Blob Storage container that you are uploading the results to.

    .PARAMETER StorageAccountPathTopLevel
    This feature allows the user to specify of the name of the test run report. This name is refected in the Azure Storage Account and Power BI report.

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
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    [Parameter(Mandatory=$true)]
    [string]
    $TestName="",
    [Parameter(Mandatory=$true)]
    [String[]]
    $PublishPreviousResultsToStorageAccount,
    [Parameter(Mandatory=$false)]
    [switch]
    $PublishTestToStorageAccount,
    [Parameter(Mandatory=$true)]
    [string]
    $StorageAccount="",
    [Parameter(Mandatory=$true)]
    [string]
    $Container="",
    [Parameter(Mandatory=$false)]
    [string]
    $StorageAccountPathTopLevel="",
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

if (!($null -eq $PublishPreviousResultsToStorageAccount) && !($PublishPreviousResultsToStorageAccount -eq "")) 
{
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

    Write-Output "Publishing previous results to storage account"

    $accountKey=RetrieveStorageAccountKey -storageAccountName $StorageAccount

    foreach($file in $PublishPreviousResultsToStorageAccount) 
    {
        $addBlobToStorageAccount=$true

        # Making sure jtl file is present
        IsJTLPresent -resultFile $file
        $resultFile=Get-ChildItem -Path $file -force | Where-Object Extension -in ('.jtl')
        if ((Get-Content $resultFile).Length -le 1) 
        {
            Write-Output ".jtl file is empty"
            throw "Empty .jtl file found. jtl file with test results is required"
        }  
    
        # Retrieving timestamp in results file
        $readFile = New-Object System.IO.StreamReader($resultFile)
        $header=$readFile.ReadLine()
        $firstResultLine=$readFile.ReadLine()

        # Making sure file does not only include header
        if ($null -eq $firstResultLine)
        {
            Write-Output ".jtl file has no results."
            throw ".jtl file with test results is required"
        }

        $timestamp=$firstResultLine.Substring(0,$firstResultLine.IndexOf(','))
        $destinationPath=ConvertUnixTimeToUTC -timestamp $timestamp

        # Retrieving test plan name from parameter or using default Test Plan name
        [xml]$testPlanXml=Get-Content $TestName
         $testPlanName=$testPlanXml.SelectNodes("//TestPlan").testname
        if (!($null -eq $StorageAccountPathTopLevel) -and !($StorageAccountPathTopLevel -eq "")) 
        {
            $destinationPath = $StorageAccountPathTopLevel + "/" + $destinationPath
        }
        elseif (!($testPlanName -eq "Test Plan") -and !($testPlanName -eq "") -and !($null -eq $testPlanName)) 
        {
            $destinationPath = $testPlanName + "/" + $destinationPath
        }
        else 
        {
            $destinationPath = "Test Plan/" + $destinationPath
        }

        # Creating report folder name
        $ReportFolderName="$(ConvertUnixTimeToFileDateTimeUniversal -timestamp $timestamp)results"
        $blob="$($destinationPath)/$($ReportFolderName)/results.jtl"
        
        # Creating report folder 
        DoesReportDirectoryExist -reportFolderName $ReportFolderName
        $currentWorkingDirectory=Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
        $isTestInReport=$PublishTestToStorageAccount.IsPresent
        CreateReportDirectory -reportFolderName $ReportFolderName -resultFile $resultFile -currentWorkingDirectory $currentWorkingDirectory -isTestInReport $isTestInReport -testName $TestName
        Write-Output "Publishing $($ReportFolderName) to $($currentWorkingDirectory)"

        # Adding result folder to storage account
        Write-Output "Publishing to storage account $StorageAccount to folder $destinationPath"
        Write-Output "Adding the AZ storage-preview extension"
        az extension add --name storage-preview
        Write-Output "Attempting to upload to storage account using the current AZ Security context"
        PublishResultsToStorageAccount -container $Container -StorageAccountName $StorageAccount -DestinationPath $destinationPath -SourceDirectory $ReportFolderName

        # Starting Azure Instance 
        Write-Output "Starting Azure Container Instance"
        StartAzureContainerInstace -azureContainerInstance $AzureContainerInstance -resourceGroup $ResourceGroup
    }
}
