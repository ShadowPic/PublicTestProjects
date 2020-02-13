param(
    [Parameter(Mandatory=$true)]
    [string]$tenant,
    [Parameter(Mandatory=$true)]
    [string]$AksResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]$AksClusterName,
    [Parameter(Mandatory=$false)]
    [bool]$ExposeGrafanaExternally=$false,
    [Parameter(Mandatory=$false)]
    [string]$SubDns

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
helm init --service-account tiller  --wait
log "Creating AKS Namespace"
kubectl create namespace $tenant
#timing issue may be here
if($ExposeGrafanaExternally)
{
    log "Installing nginx"
    helm install stable/nginx-ingress --namespace $tenant --set controller.replicaCount=1 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux --wait
    log "Getting Public IP address"
    $RetryCount=0
    $Complete=$false
    [string]$PUBLICIPID=""
    while(-not $Complete)
    {
        $nginxPublicIP = $(kubectl -n $tenant get service -o json|convertfrom-json).items.status.LoadBalancer.ingress.ip
        $AksVmResourceGroup=$(az aks list --query "[?name=='$($AksClusterName)'].nodeResourceGroup" -o tsv)
        $PUBLICIPID=$(az network public-ip list --resource-group $AksVmResourceGroup --query "[?ipAddress=='$($nginxPublicIP)']|[?contains(ipAddress, '$IP')].[ id]" --output tsv)
        if(-not($null -eq $PUBLICIPID) -and -not($PUBLICIPID -eq ""))
        {
            $Complete=$true;
        } 
        if(($RetryCount -gt 3) -and (-not $Complete))
        {
            log "failed to obtain an IP address"
            throw 
        }
        $RetryCount ++   
        Start-Sleep -Seconds 3
    }
    log "Public IP ID: $($PUBLICIPID)"
    if(($PUBLICIPID -eq $null) -or ($PUBLICIPID -eq ""))
    {
        log "Failed to get the public ip address id"
        return;
    }
    log "Adding DNS suffix"
    az network public-ip update --ids $PUBLICIPID --dns-name $SubDns
    kubectl create namespace cert-manager
    kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
    # Install the CustomResourceDefinition resources separately 
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml 
    helm repo update
    log "Install the cert-manager Helm chart"
    helm install --name cert-manager --namespace cert-manager --version v0.8.0 jetstack/cert-manager --wait
    Start-Sleep -Seconds 30
    kubectl apply -f cluster-issuer-prod.yaml
}
kubectl -n $tenant apply -f .\jmeter_grafana_deploy.yaml
kubectl -n $tenant rollout status deployment jmeter-grafana
if($ExposeGrafanaExternally)
{
    kubectl -n $tenant apply -f .\jmeter_grafana_ingress-prod.yaml
}
# the ingress has the fqdn of the grafana service.  this may require a helm chart to make this generic.