#Requires -Version 7
param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    # Add more than 2 instances
    [Parameter(Mandatory=$false)]
    [int]
    $ScaleSlaves = 2
)

$PathToYaml = Split-Path $MyInvocation.MyCommand.Path -Parent

Set-Location $PathToYaml

Import-Module ./commenutils.psm1 -force

VerifyKubeCtl

kubectl version --short

VerifyHelm3

[bool] $IsHelmDeployed = IsJmeterHelmDeployed -tenant $tenant
Write-Output "Checking if Helm is deployed on $($tenant): $($IsHelmDeployed)"
if($IsHelmDeployed -eq $false)
{
    write-output "Installing the jmetertestrig helm chart to namespace $tenant"
    Helm install jmeter jmetertestrig --namespace $tenant --wait

    write-output "Upgrading the jmetertestrig helm chart to namespace $tenant"
    Helm upgrade jmeter jmetertestrig --namespace $tenant --wait
    
    write-output "Creating JMeter Influx database"

    $InfluxPod = $(kubectl -n $tenant get pods --selector=app=influxdb --no-headers=true --output=name).Replace("pod/","")

    kubectl -n $tenant exec $InfluxPod -- curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE jmeter"

}

./Set-JmeterTestRig.ps1 -tenant $tenant -ZeroOutTestRig $true
./Set-JmeterTestRig.ps1 -tenant $tenant -JmeterSlaveCount $ScaleSlaves

