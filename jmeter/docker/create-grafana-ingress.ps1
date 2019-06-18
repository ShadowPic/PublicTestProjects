param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    [Parameter(Mandatory=$true)]
    [string]
    $SubDns

)
#see https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Label the cert-manager namespace to disable resource validation
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install --name cert-manager --namespace cert-manager --version v0.8.0 jetstack/cert-manager

Write-Output "Installing nginx"
helm install stable/nginx-ingress --namespace $tenant --set controller.replicaCount=1 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

Write-Output "Get the IP address of the ingress Load Balancer"
$nginxPublicIP = $(kubectl -n $tenant get service -o json|convertfrom-json).items.status.LoadBalancer.ingress.ip

# Get the resource-id of the public ip
$PublicIpID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$nginxPublicIP')].[id]" --output tsv) 

az network public-ip update --ids $PublicIpID --dns-name $SubDns



#create CA Cluster issuer
kubectl -n $tenant apply -f cluster_issuer.yaml

kubectl -n $tenant rollout status -f cluster-issuer.yaml

#create certificate
kubectl -n $tenant apply -f grafana-certificate.yaml

kubectl -n $tenant rollout status -f grafana-certificate.yaml
#create ingress route
kubectl -n $tenant apply -f jmeter_grafana_ingress.yaml