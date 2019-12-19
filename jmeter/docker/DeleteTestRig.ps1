param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
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
log "Deleting AKS Instance"
az aks delete --name $AksClusterName --resource-group $AksResourceGroup -y
log "Removing local auth"
kubectl config use-context docker-desktop
kubectl config delete-context $AksClusterName
kubectl config delete-cluster $AksClusterName
kubectl config unset "users.clusterUser_$($AksClusterName)_$($AksClusterName)"