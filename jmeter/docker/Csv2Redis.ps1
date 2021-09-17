<#
    .SYNOPSIS
    Executes Csv2Redis executable on a AKS cluster.

    .DESCRIPTION
    The Csv2Redis.ps1 script provides a highly flexible method to execute convert a jmeter script containing CSV configuration to Redis configuration and store in a report folder locally.

    .PARAMETER Tenant
    Theoretically this allows for multiple concurrent jmeter deployments on a common AKS cluster.  Please note
    that this feature has not been functionally tested yet.

    .PARAMETER TestScript
    JMX test script to convert to Redis.  Do not include path name just the jmx file name.

    .PARAMETER CsvAndJmxFilesDir
    The folder which contains the test script and the csv files supporting it.
    
    .INPUTS
    None. You cannot pipe objects to Csv_Redis.ps1

    .EXAMPLE
    PS> .\Csv2Redis.ps1 -tenant jmeter -TestScript redis.jmx -CsvAndJmxFilesDir ./jmxandcsvfiles

#>

#Requires -Version 7

param(
    [Parameter(Mandatory=$true)]
    [Alias("namespace")]
    [string]
    $tenant,
    [Parameter(Mandatory=$true)]
    [string]
    $TestScript,
    [Parameter(Mandatory=$true)]
    [string]
    $CsvAndJmxFilesDir,
    # Switch to whether or not to add an influx db listener
    [Parameter(Mandatory=$false)]
    [switch] $AddInfluxDbListener
)

Import-Module ./commenutils.psm1 -force

$PodWorkingDir="working"
$Csv2redisPod= $(kubectl -n $tenant get pods --selector=app=csv2redis --no-headers=true --output=name).Replace("pod/","")

Write-Output "Copying CsvAndJmxDir"
kubectl cp $CsvAndJmxFilesDir "$tenant/${Csv2redisPod}:/app/${PodWorkingDir}"

if(!$AddInfluxDbListener){
    Write-Output "Creating Redis version"
    kubectl -n $tenant exec $Csv2redisPod -- /app/Csv2RedisScript --testscript "./${PodWorkingDir}/${testscript}"
}
else {
    Write-Output "Creating Redis version and adding InfluxDb Listener"
    kubectl -n $tenant exec $Csv2redisPod -- /app/Csv2RedisScript --testscript "./${PodWorkingDir}/${testscript}" --AddBackEndListener true
}
Write-Output "Copying contents of CsvAndJmxFilesDir"
kubectl cp "$tenant/${Csv2redisPod}:/app/${PodWorkingDir}" ./

Write-Output "Resetting csv2redis pod"
kubectl -n $tenant delete pod $Csv2redisPod 

$ModifiedTestScript = $TestScript.Substring(0,$TestScript.IndexOf(".")) + "-modified.jmx"
write-output "`n`nRun this command to run test using your redis file: `n`n.\run_test.ps1 -tenant $($tenant) -TestName $($ModifiedTestScript) -RedisScript csv2redis.redis`n`n"
