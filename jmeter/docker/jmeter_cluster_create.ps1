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

$PathToYaml = Split-Path $MyInvocation.MyCommand.Path -Parent

Set-Location $PathToYaml

if ($null -eq (Get-Command "kubectl.exe" -ErrorAction SilentlyContinue)) 
{ 
   Write-Host "Unable to find kubectl.exe in your PATH"
   throw "kubectl is required"
}

kubectl version --short

Write-Output "Verifying Helm v3.* is installed"

$testHelm=helm version |Select-String -Pattern "v3."

if(($null -eq (Get-Command "helm.exe" -ErrorAction SilentlyContinue)) -and ($null -ne ($testHelm=helm version |Select-String -Pattern "v3.")))
{
    Write-Host "Wrong version or Helm does not exist"
    throw "helm is not right"
}

Write-Output "Installing redis"


helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo

helm -n jmeter install --set usePassword=false jmeterredis azure-marketplace/redis --wait

Write-Output "Creating Jmeter slave nodes"

kubectl apply -n $tenant -f jmeter_slaves_deploy.yaml

if($ScaleSlaves -gt 2)
{
    kubectl scale -n $tenant --replicas=$ScaleSlaves deployment/jmeter-slaves
}

Write-Output "Creating Influxdb and the service"

kubectl apply -n $tenant -f jmeter_influxdb_deploy.yaml

kubectl -n $tenant rollout status deployment influxdb-jmeter

write-output "Creating JMeter Influx database"

$InfluxPod = $(kubectl -n $tenant get pods --selector=app=influxdb-jmeter --no-headers=true --output=name).Replace("pod/","")

kubectl -n $tenant exec $InfluxPod -- curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE jmeter"

Write-Output "Creating Jmeter Master"

kubectl create -n $tenant -f jmeter_master_deploy.yaml

kubectl -n $tenant rollout status deployment jmeter-master

kubectl -n $tenant rollout status deployment jmeter-slaves



