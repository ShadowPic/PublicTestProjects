#Requires -Version 7

param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    [Parameter(Mandatory=$false)]
    [string]
    $TestName="",
    [Parameter(Mandatory=$true)]
    [string]
    $PublishPreviousResultsToStorageAccount,
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

    IsJTLPresent -resultFile $PublishPreviousResultsToStorageAccount
    $resultFile=Get-ChildItem -Path $PublishPreviousResultsToStorageAccount -force | Where-Object Extension -in ('.jtl')
    if ((Get-Content $resultFile).Length -le 1) 
    {
        Write-Host ".jtl file is empty"
        throw "jtl file with test results is required"
    }
 
    
    $firstResultLine=Get-Content -Path $resultFile | Select-Object -index 1
    $timestamp=$firstResultLine.Substring(0,$firstResultLine.IndexOf(','))
    $destinationPath=ConvertUnixTimeToUTC -timestamp $timestamp

    [xml]$testPlanXml=Get-Content $TestName
    if(!($testPlanXml.SelectNodes("//TestPlan").testname -eq "Test Plan"))
    {
        $destinationPath = $testPlanXml.SelectNodes("//TestPlan").testname + "/" + $destinationPath
    }  

    Write-Output "Publishing to storage account $StorageAccount to folder $destinationPath"
    Write-Output "Adding the AZ storage-preview extension"
    az extension add --name storage-preview
    Write-Output "Attempting to upload to storage account using the current AZ Security context"
    PublishResultsToStorageAccount -container $Container -StorageAccountName $StorageAccount -DestinationPath $destinationPath -SourceDirectory $PublishPreviousResultsToStorageAccount
}