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

Import-Module ./commenutils.psm1 -DisableNameChecking

VerifyKubeCtl

if($ZeroOutTestRig)
{
    Write-Host "Removing jmeter master and slaves"
    kubectl -n $tenant scale deployments/jmeter-master --replicas 0
    kubectl -n $tenant scale deployments/jmeter-slaves --replicas 0
    kubectl -n $tenant wait --for=delete pods --selector=jmeter_mode=master --timeout=120s
    kubectl -n $tenant wait --for=delete pods --selector=jmeter_mode=slave --timeout=120s
    return
}

    kubectl -n $tenant scale deployments/jmeter-master --replicas 1
    kubectl -n $tenant scale deployments/jmeter-slaves --replicas $JmeterSlaveCount
    kubectl -n $tenant rollout status deployment jmeter-master
    kubectl -n $tenant rollout status deployment jmeter-slaves
