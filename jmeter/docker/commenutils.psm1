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