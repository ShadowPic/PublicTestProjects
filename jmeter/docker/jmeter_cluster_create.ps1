param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    # Add more than 2 instances
    [Parameter(Mandatory=$false)]
    [int]
    $ScaleSlaves = 0,
    [Parameter(Mandatory=$true)]
    [string]
    $StorageAccount,
    [Parameter(Mandatory=$true)]
    [string]
    $StorageResourceGroup
)

Write-Output "checking if kubectl is present"

$PathToYaml = Split-Path $MyInvocation.MyCommand.Path -Parent

Set-Location $PathToYaml

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

$storage_key=$(az storage account keys list --resource-group $StorageResourceGroup --account-name $StorageAccount --query "[0].value" -o tsv)
kubectl -n $tenant create secret generic azure-secret --from-literal=azurestorageaccountname=$StorageAccount --from-literal=azurestorageaccountkey=$STORAGE_KEY

Write-Output "Creating Influxdb and the service"

kubectl create -n $tenant -f jmeter_influxdb_configmap.yaml

kubectl create -n $tenant -f jmeter_influxdb_deploy.yaml

kubectl create -n $tenant -f jmeter_influxdb_svc.yaml

kubectl -n $tenant rollout status -f .\jmeter_influxdb_deploy.yaml

Write-Output "Creating Jmeter Master"

kubectl create -n $tenant -f jmeter_master_configmap.yaml

kubectl create -n $tenant -f jmeter_master_deploy.yaml

kubectl -n $tenant rollout status -f .\jmeter_slaves_deploy.yaml

