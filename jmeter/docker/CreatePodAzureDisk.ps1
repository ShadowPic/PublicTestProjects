$AKSResourceGroup="<hide>"
$AKSCluster="<hide>"
$DiskName="myAKSDisk"
$NodeResourceGroup=az aks show --resource-group $AKSResourceGroup --name $AKSCluster --query nodeResourceGroup -o tsv
$DiskResourceID=az disk create --resource-group $NodeResourceGroup --name $DiskName --size-gb 20 --query id --output tsv