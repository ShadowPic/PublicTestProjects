<#
    .SYNOPSIS
    Executes Csv2Redis executable on a AKS cluster.

    .DESCRIPTION
    The Csv2Redis.ps1 script provides a highly flexible method to execute convert a CSV to Redis and store in a report folder locally.

    .PARAMETER Tenant
    Theoretically this allows for multiple concurrent jmeter deployments on a common AKS cluster.  Please note
    that this feature has not been functionally tested yet.

    .PARAMETER TestScript
    JMX test script to convert to Redis.  Do not include path name just the jmx file name.

    .PARAMETER CsvAndJmxFilesDir
    The folder which contains the test script and the csv files supporting it.
    
    .INPUTS
    None.  You cannot pipe objects to Csv_Redis.ps1

    .EXAMPLE
    PS> .\Csv2Redis.ps1 -tenant jmeter -TestScript redis.jmx -CsvAndJmxFilesDir ./jmxandcsvfiles

#>

#Requires -Version 7

param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    [Parameter(Mandatory=$true)]
    [string]
    $TestScript,
    [Parameter(Mandatory=$true)]
    [string]
    $CsvAndJmxFilesDir
)

Import-Module ./commenutils.psm1 -force

$PodWorkingDir="working"
$Csv2redisPod= $(kubectl -n $tenant get pods --selector=app=csv2redis --no-headers=true --output=name).Replace("pod/","")
kubectl cp $CsvAndJmxFilesDir "$tenant/${Csv2redisPod}:/app/${PodWorkingDir}"
kubectl -n $tenant exec $Csv2redisPod -- /app/Csv2RedisScript --testscript "./${PodWorkingDir}/${testscript}"
kubectl cp "$tenant/${Csv2redisPod}:/app/${PodWorkingDir}" ./
kubectl -n $tenant delete pod $Csv2redisPod 
write-output "`n`nRun this command to run test using your redis file: `n`n.\run_test.ps1 -tenant jmeter -TestName <your-test.jmx> -RedisScript csv2redis.redis`n`n"
