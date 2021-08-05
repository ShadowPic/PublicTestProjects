#Requires -Version 7
function VerifyKubeCtl
{
    if ($null -eq (Get-Command "kubectl.exe" -ErrorAction SilentlyContinue))
    {
        Write-Host "Unable to find kubectl.exe in your PATH"
        throw "kubectl is required"
    }
}

function VerifyHelm3
{
    Write-Output "Verifying Helm v3.* is installed"

    if(($null -eq (Get-Command "helm.exe" -ErrorAction SilentlyContinue)) -and ($null -ne ($testHelm=helm version |Select-String -Pattern "v3.")))
    {
        Write-Host "Wrong version or Helm does not exist"
        throw "helm is not right"
    }

}

function IsJmeterHelmDeployed($tenant)
{

    [string]$deploymentStatus=Helm status jmeter --namespace jmeter
    [boolean]$match = $deploymentStatus -like "*STATUS: deployed*"
    return $match
}

function GetRedisMaster ($tenant)
{
    return (kubectl -n $tenant get pod --selector=app=redis --selector=role=master -o json|ConvertFrom-Json).items.metadata.name
}

function JmeterMasterDeploymentName ($tenant)
{
    return (kubectl -n $tenant get deployment --selector=jmeter_mode=master -o json|ConvertFrom-Json).items.metadata.name
}

function JmeterSlaveDeploymentName ($tenant)
{
    return (kubectl -n $tenant get deployment --selector=jmeter_mode=slave -o json|ConvertFrom-Json).items.metadata.name
}

function PublishResultsToStorageAccount($container,$StorageAccountName,$DestinationPath,$SourceDirectory)
{
    az extension add --name storage-preview
    az storage azcopy blob upload --container $container --account-name $StorageAccountName --destination $DestinationPath --source $SourceDirectory --recursive
}

function IsResultInStoragAccount($container,$StorageAccountName,$blob,$accountKey)
{
    return az storage blob exists --account-key $accountKey --account-name $StorageAccountName --container-name $container --name $blob --query exists
}

function RetrieveStorageAccountKey($storageAccountName) 
{
    return az storage account keys list --account-name $StorageAccountName --query [0].value
}

function ConvertUnixTimeToUTC($timestamp)
{
    $origin=New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $timestamp=$origin.AddSeconds([double]$timestamp/1000)
    return Get-Date -Date $timestamp -format "yyyy/MM/dd" -AsUTC
    
}

function ConvertUnixTimeToFileDateTimeUniversal($timestamp)
{
    $origin=New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $timestamp=$origin.AddSeconds([double]$timestamp/1000)
    return Get-Date -Date $timestamp -format FileDateTimeUniversal -AsUTC
}

function IsJTLPresent($resultFile)
{
    [bool]$jtlPresent = (Get-ChildItem -Path $resultFile -force | Where-Object Extension -in ('.jtl') | Measure-Object).Count -ne 0

    if (!($jtlPresent))
    {
        Write-Host ".jtl file not present"
        throw ".jtl file is required"
    }
}

function CreateReportDirectory($reportFolderName,$isTestInReport,$testName,$resultFile,$currentWorkingDirectory)
{
    New-Item -Path $currentWorkingDirectory -Name $ReportFolderName -ItemType "directory"
    Copy-Item -Path $resultFile -Destination $currentWorkingDirectory"/"$ReportFolderName"/results.jtl" -Force
    Copy-Item -Path $resultFile -Destination $currentWorkingDirectory"/"$ReportFolderName -Force

    if ($isTestInReport)
    {
        Copy-Item -Path $testName -Destination $currentWorkingDirectory"/"$ReportFolderName -Force
    }
}

function DoesReportDirectoryExist($reportFolderName)
{
    if (Test-Path -Path $reportFolderName)
    {
        Remove-Item -LiteralPath $reportFolderName -Force -Recurse
    }
}

function PromptUserForTestName($destinationPath,$testPlanXml,$file) 
{
    [bool]$askAgain=$true
    while($askAgain)
    {
        if ([string]::IsNullOrEmpty($file))
        {
            $file="results.jtl"
        }
        $userInput=Read-Host -Prompt "The report is called $("Test Plan") for result file $($file). Do you want to change it? [Y or N]"
        switch ($userInput) {
            { @("n", "no") -contains $_ } { return "Test Plan/" + $destinationPath }
            { @("y", "yes") -contains $_ } 
            { 
               $testPlanName=Read-Host -Prompt "Enter Test Plan Name"
               return $testPlanName + "/" + $destinationPath 
            }
            default {'Input not recognized.'}
        }
    }
}

function VerifyCommandExists($cmdName) 
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function StartAzureContainerInstace($azureContainerInstance,$resourceGroup) 
{
    az container start --name $azureContainerInstance --resource-group $resourceGroup
}