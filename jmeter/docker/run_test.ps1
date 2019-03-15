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
    $ReportFolder
)

$MasterPod = $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name).Replace("pod/","")
kubectl cp $TestName $tenant/${MasterPod}:/
kubectl -n $tenant exec $MasterPod -- rm -r /report
kubectl -n $tenant exec $MasterPod -- rm -r /results.log
kubectl -n $tenant exec $MasterPod -- /load_test_run "/$(Split-Path $TestName -Leaf)"
kubectl cp $tenant/${MasterPod}:/report $ReportFolder