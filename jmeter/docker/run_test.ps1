param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    # Name of test
    [Parameter(Mandatory=$true)]
    [string]
    $TestName,
    # Where to put the report directory
    [Parameter(Mandatory=$true)]
    [string]
    $ReportFolder,
    [Parameter(Mandatory=$false)]
    [bool]
    $DeleteTestRig = $true,
    [Parameter(Mandatory=$false)]
    [string]
    $UserProperties=""
)
$CurrentPath = Split-Path $MyInvocation.MyCommand.Path -Parent

Set-Location $CurrentPath
if($null -eq $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name) )
{
    Write-Error "Master pod does not exist"
    exit
}
$MasterPod = $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name).Replace("pod/","")
Write-Output "Checking for user properties"
if(!($UserProperties -eq $null -or $UserProperties -eq "" ))
{
    Write-Output "Copying user.properties over"
    kubectl cp $UserProperties $tenant/${MasterPod}:/jmeter/apache-jmeter-5.1.1/bin/user.properties
}
kubectl cp $TestName $tenant/${MasterPod}:"/$(Split-Path $TestName -Leaf)"

kubectl -n $tenant exec $MasterPod -- /load_test_run "/$(Split-Path $TestName -Leaf)"
kubectl cp $tenant/${MasterPod}:/report $ReportFolder
kubectl cp $tenant/${MasterPod}:/results.log $ReportFolder/results.log
kubectl cp $tenant/${MasterPod}:/jmeter/apache-jmeter-5.1.1/bin/jmeter.log $ReportFolder/jmeter.log
if($DeleteTestRig)
{
    kubectl -n $tenant delete -f jmeter_master_deploy.yaml
    kubectl -n $tenant delete -f jmeter_slaves_deploy.yaml
    #helm del --purge redis-release
}