param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant
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

Write-Output "Creating Jmeter Master"

kubectl create -n $tenant -f jmeter_master_configmap.yaml

kubectl create -n $tenant -f jmeter_master_deploy.yaml


# echo "Creating Influxdb and the service"

# kubectl create -n $tenant -f $working_dir/jmeter_influxdb_configmap.yaml

# kubectl create -n $tenant -f $working_dir/jmeter_influxdb_deploy.yaml

# kubectl create -n $tenant -f $working_dir/jmeter_influxdb_svc.yaml

# echo "Creating Grafana Deployment"

# kubectl create -n $tenant -f $working_dir/jmeter_grafana_deploy.yaml

# kubectl create -n $tenant -f $working_dir/jmeter_grafana_svc.yaml

# echo "Printout Of the $tenant Objects"

# echo

# kubectl get -n $tenant all

# echo namespace = $tenant > $working_dir/tenant_export
