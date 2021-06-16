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
    $PublishTestToSotrageAccount,
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

    foreach($file in $PublishPreviousResultsToStorageAccount) 
    {
        IsJTLPresent -resultFile $file
        $resultFile=Get-ChildItem -Path $file -force | Where-Object Extension -in ('.jtl')
        if ((Get-Content $resultFile).Length -le 1) 
        {
            Write-Output ".jtl file is empty"
            throw "jtl file with test results is required"
        }
    
        # TODO: look into using stream to grab first line
        $firstResultLine=Get-Content -Path $resultFile | Select-Object -index 1 
        $timestamp=$firstResultLine.Substring(0,$firstResultLine.IndexOf(','))
    
        # Creating report folder 
        $ReportFolderName="$(ConvertUnixTimeToFileDateTimeUniversal -timestamp $timestamp)results"
        if (Test-Path -Path $ReportFolderName) 
        {
            Write-Output "$($ReportFolderName) already exists"
            throw "Results file is already in storage account"
        } 
        else 
        {
            $currentWorkingDirectory=Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
            New-Item -Path $currentWorkingDirectory -Name $ReportFolderName -ItemType "directory"
            Copy-Item -Path $resultFile -Destination $currentWorkingDirectory"/"$ReportFolderName"/results.jtl" -Force
            Copy-Item -Path $resultFile -Destination $currentWorkingDirectory"/"$ReportFolderName -Force

            if ($PublishTestToSotrageAccount.IsPresent) 
            {
                Copy-Item -Path $TestName -Destination $currentWorkingDirectory"/"$ReportFolderName -Force
            }
            
    
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
            PublishResultsToStorageAccount -container $Container -StorageAccountName $StorageAccount -DestinationPath $destinationPath -SourceDirectory $ReportFolderName
        }
    }
}