$tenant="jmeter"
$SubDns="drgrafana"
helm install stable/nginx-ingress --namespace $tenant --set controller.replicaCount=1 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux --wait
# Get the resource-id of the public ip
$nginxPublicIP = $(kubectl -n $tenant get service -o json|convertfrom-json).items.status.LoadBalancer.ingress.ip
# Get the resource-id of the public ip
$PublicIpID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$nginxPublicIP')].[id]" --output tsv) 
# set the .left name
az network public-ip update --ids $PublicIpID --dns-name $SubDns

