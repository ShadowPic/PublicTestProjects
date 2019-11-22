param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    [Parameter(Mandatory=$true)]
    [string]
    $SubDns,
    [Parameter(Mandatory=$true)]
    [string]
    $AksResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]
    $AksClusterName

)

function log([string] $message)
{
    Write-Output "$(get-date) $message"    
}
if($(az account list).contains("[]")){
     Exit-PSSession
}

log "Creating aks cluster"
az aks create --resource-group $AksResourceGroup   --name $AksClusterName   --node-count 1  --enable-addons monitoring  --generate-ssh-keys
log "Getting cluster credentials"
az aks get-credentials --name $AksClusterName --resource-group $AksResourceGroup
log "Setting up k8s dashboard role binding"
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
log "Seting helm rbac"
kubectl apply -f helm-rbac.yaml
# may need to add code here to wait for the policy to be applied
log "Starting tiller"
helm init --service-account tiller
