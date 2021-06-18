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
    $Container=""
)

Import-Module ./commenutils.psm1 -force

if (!($null -eq $PublishPreviousResultsToStorageAccount) && !($PublishPreviousResultsToStorageAccount -eq "")) 
{
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
            throw "jtl file with test results is required"
        }
    
        # Retrieving timestamp in results file
        $readFile = New-Object System.IO.StreamReader($resultFile)
        $header=$readFile.ReadLine()
        $firstResultLine=$readFile.ReadLine()
        $timestamp=$firstResultLine.Substring(0,$firstResultLine.IndexOf(','))
        $destinationPath=ConvertUnixTimeToUTC -timestamp $timestamp

        # Retrieving test plan name
        [xml]$testPlanXml=Get-Content $TestName
        if(!($testPlanXml.SelectNodes("//TestPlan").testname -eq "Test Plan"))
        {
            $destinationPath = $testPlanXml.SelectNodes("//TestPlan").testname + "/" + $destinationPath
        } 
    
        # Creating report folder name
        $ReportFolderName="$(ConvertUnixTimeToFileDateTimeUniversal -timestamp $timestamp)results"
        $blob="$($destinationPath)/$($ReportFolderName)/results.jtl"
        
        # Checking if results file is already in storage account
        $blobExists = IsResultInStoragAccount -container $Container -StorageAccountName $StorageAccount -blob $blob -accountKey $accountKey
        if ($blobExists -eq "true")
        {
            [bool]$askAgain=$true
            while($askAgain)
            {
                $userInput=Read-Host -Prompt "$($file) already exists in storage account. Do you want to overwrite it? [Y or N]"
                switch ($userInput) {
                    { @("n", "no") -contains $_ } 
                    { 
                        $askAgain=$false
                        $addBlobToStorageAccount=$false
                    }
                    { @("y", "yes") -contains $_ } { $askAgain=$false }
                    default {'Input not recognized.'}
                }
            }
        }

        if ($addBlobToStorageAccount)
        {
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
        }
    }
}
