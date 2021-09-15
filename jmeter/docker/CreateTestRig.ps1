#Requires -Version 7
param(
    [Parameter(Mandatory=$true)]
    [Alias("namespace")]
    [string]$tenant,
    [Parameter(Mandatory=$true)]
    [string]$AksResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]$AksClusterName,
    [Parameter(Mandatory=$false)]
    [string]$NodeVmSize="Standard_DS2_v2",
    [Parameter(Mandatory=$false)]
    [switch] $EnableClusterAutoscaler,
    [Parameter(Mandatory=$false)]
    [int]$MinimumNodeCount=1,
    [Parameter(Mandatory=$false)]
    [int]$MaxNodeCount=5
)

function log([string] $message)
{
    Write-Output "$(get-date) $message"    
}
if($(az account list).contains("[]")){
     Exit-PSSession
}
if($EnableClusterAutoscaler){
    az aks create `
        --resource-group $AksResourceGroup `
        --name $AksClusterName `
        --enable-managed-identity `
        --vm-set-type VirtualMachineScaleSets `
        --node-vm-size $NodeVmSize  `
        --generate-ssh-keys `
        --enable-cluster-autoscaler `
        --min-count $MinimumNodeCount `
        --max-count $MaxNodeCount

}
else {
    az aks create `
        --resource-group $AksResourceGroup `
        --name $AksClusterName `
        --enable-managed-identity `
        --vm-set-type VirtualMachineScaleSets `
        --node-vm-size $NodeVmSize  `
        --node-count 1 `
        --generate-ssh-keys 
}
log "Creating aks cluster"

log "Getting cluster credentials"
az aks get-credentials --name $AksClusterName --resource-group $AksResourceGroup --admin --overwrite-existing
# log "Setting up k8s dashboard role binding"
# kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
log "Installing helm stable repo"
helm repo add stable https://charts.helm.sh/stable
# may need to add code here to wait for the policy to be applied
log "Creating AKS Namespace"
kubectl create namespace $tenant
#timing issue may be here
kubectl -n $tenant apply -f ./jmeter_grafana_deploy.yaml
kubectl -n $tenant rollout status deployment jmeter-grafana