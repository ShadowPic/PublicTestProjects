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
        # TODO: look into using stream to grab first line
        $firstResultLine=Get-Content -Path $resultFile | Select-Object -index 1 
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
                $userInput = $userInput.ToUpper()
                switch ($userInput) {
                    'N'
                    { 
                        $askAgain=$false
                        $addBlobToStorageAccount=$false
                    }
                    'Y'{ $askAgain=$false }
                    Default {'Input not recognized.'}
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
