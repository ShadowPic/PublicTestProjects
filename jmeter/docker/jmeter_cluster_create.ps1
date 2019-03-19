param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    # Add more than 2 instances
    [Parameter(Mandatory=$false)]
    [int]
    $ScaleSlaves = 0
)

Write-Output "checking if kubectl is present"

if ($null -eq (Get-Command "kubectl.exe" -ErrorAction SilentlyContinue)) 
{ 
   Write-Host "Unable to find kubectl.exe in your PATH"
   throw "kubectl is required"
}

kubectl version --short

Write-Output "Creating Namespace: $tenant"

kubectl create namespace $tenant

Write-Output "Creating Jmeter slave nodes"

kubectl create -n $tenant -f jmeter_slaves_deploy.yaml

kubectl create -n $tenant -f jmeter_slaves_svc.yaml
if($ScaleSlaves -gt 2)
{
    kubectl scale -n $tenant --replicas=$ScaleSlaves deployment/jmeter-slaves
}
Write-Output "Creating Jmeter Master"

kubectl create -n $tenant -f jmeter_master_configmap.yaml

kubectl create -n $tenant -f jmeter_master_deploy.yaml
