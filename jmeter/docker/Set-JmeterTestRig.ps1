[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $tenant,
    [Parameter(Mandatory=$false)]
    [Boolean]
    $ZeroOutTestRig = $false,
    [Parameter(Mandatory=$false)]
    $JmeterSlaveCount=1
)

Import-Module ./commenutils.psm1 -force

VerifyKubeCtl

$jmeterMasterDeploymentName=JmeterMasterDeploymentName -tenant $tenant
$jmeterSlaveDeploymentName=JmeterSlaveDeploymentName -tenant $tenant

if($ZeroOutTestRig)
{
    Write-Host "Removing jmeter master and slaves"
    kubectl -n $tenant scale deployment $jmeterMasterDeploymentName --replicas 0
    kubectl -n $tenant scale deployment $jmeterSlaveDeploymentName --replicas 0
    kubectl -n $tenant wait --for=delete pods --selector=jmeter_mode=master --timeout=120s
    kubectl -n $tenant wait --for=delete pods --selector=jmeter_mode=slave --timeout=120s
    return
}

    kubectl -n $tenant scale deployment $jmeterMasterDeploymentName --replicas 1
    kubectl -n $tenant scale deployments $jmeterSlaveDeploymentName --replicas $JmeterSlaveCount
    #kubectl -n $tenant rollout status deployment $jmeterMasterDeploymentName
    #kubectl -n $tenant rollout status deployment $jmeterSlaveDeploymentName
    kubectl -n $tenant describe service jmeter-slaves-svc| Select-String -Pattern "Endpoints\:\s*\d{2,}.\d{1,}.\d{1,}.\d{1,}:1099"
    while($null -eq (kubectl -n $tenant describe service jmeter-slaves-svc| Select-String -Pattern "Endpoints\:\s*\d{2,}.\d{1,}.\d{1,}.\d{1,}:1099"))
    {
        Write-Output "Waiting for jmeter slaves endpoints to come up"
        start-sleep -Seconds 5
    };
