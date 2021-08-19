<#
    .SYNOPSIS
    Executes Csv2Redis executable on a AKS cluster.

    .DESCRIPTION
    The Csv2Redis.ps1 script provides a highly flexible method to execute convert a CSV to Redis and store in a report folder locally.

    .PARAMETER Tenant
    Theoretically this allows for multiple concurrent jmeter deployments on a common AKS cluster.  Please note
    that this feature has not been functionally tested yet.

    .PARAMETER TestScript
    JMX test script to convert to Redis

    .PARAMETER ContainerName
    The name of your Azure Container
    
    .INPUTS
    None.  You cannot pipe objects to Csv_Redis.ps1

    .EXAMPLE
    PS> .\Csv2Redis.ps1 -tenant jmeter -TestScript redis.jmx -ResourceGroup resource-group -ContainerName container-name

#>

#Requires -Version 7

param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    [Parameter(Mandatory=$true)]
    [string]
    $TestScript,
    [Parameter(Mandatory=$true,HelpMessage="Resource group for the ACI instance")]
    [string]$ResourceGroup,
    [Parameter(Mandatory=$true,HelpMessage="Container name")]
    [string]$ContainerName
)

Import-Module ./commenutils.psm1 -force

$ReportFolder="$(get-date -Format FileDateTimeUniversal -AsUTC)results"
if($null -eq $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name) )
{
    Write-Error "Master pod does not exist"
    exit
}
$MasterPod = $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name).Replace("pod/","")

# Kubernetes copy from local to container
cd ../../source/Csv2RedisScript/Csv2RedisScript/bin/Debug/netcoreapp3.1
./Csv2RedisScript.exe /u .\Csv2RedisScript.dll --testscript $TestScript
kubectl cp csv2redis.redis $tenant/${MasterPod}:csv2redis.redis

# Deploy Kubernetes
cd ../../../
kubectl apply -f .\csv2redis.yaml
cd ../../../

# Deploy Azure Container
cd jmeter/docker
az container create --resource-group $ResourceGroup --name $ContainerName --image shadowpic/csv2redis:latest --environment-variables RunOnceAndStop="true"

# Execute 
kubectl exec $MasterPod --container $ContainerName -- /bin/bash

# Kubernetes copy from container to local 
kubectl cp $tenant/${MasterPod}:csv2redis.redis $ReportFolder/csv2redis.redis

 write-output "`n`nRun this command to run test using your redis file: `n`n.\run_test.ps1 -tenant jmeter -TestName <your-test.jmx> -ReportFolder $($ReportFolder) -RedisScript $($ReportFolder)/csv2redis.redis`n`n"
