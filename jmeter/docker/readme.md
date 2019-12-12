# Overview
This project is a very lean implementation of a Kubernetes JMeter cluster.  It will allow for the execution of a JMeter test script on an arbitrarily sized [JMeter test rig](https://jmeter.apache.org/usermanual/jmeter_distributed_testing_step_by_step.html#distributed-testing) and then will generate:
- A [JMeter DashBoard Report](http://jmeter.apache.org/usermanual/generating-dashboard.html#generation)
- [JMeter Test Log \(JTL\)](https://jmeter.apache.org/usermanual/get-started.html#non_gui)
   
To provide a simple method of deleting the test rig after the test execution we are using the [Kubernetes Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) feature which allows for an expedited method to delete everything created.

[**kubectl delete namespace *NameSpacdName***](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete)

## Features
- Certified on [AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/)
- PowerShell scripts automate all of the features 
  - All samples that I found assumed a Linux client and no PoserShell
  - Linux based containers whicdh allow for K8S native pod clustering
- PowerShell script to create your own docker images if you don't want to use mine at https://cloud.docker.com/u/shadowpic
- Build the cluster from Docker root containers
- Real time monitoring of the performance test with Grafana
- Combine Azure PAS service metrics side by side with JMeter metrics using Grafana
- Redis support to feed parameters to your tests

## Dependendies
- Docker for Windwos Desktop: https://docs.docker.com/docker-for-windows/install/
- Azure Client: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
- AKS: https://azure.microsoft.com/en-us/services/kubernetes-service/
- Helm version 2.*: https://github.com/helm/helm 

To create a basic load test
- JMeter 5.x: https://jmeter.apache.org/download_jmeter.cgi
- JMeter Plugins: https://jmeter-plugins.org/
- A web site somewhere that you can break and not get in trouble.  :)

## To Delete Prior Cluster Client Context
    kubectl config use-context docker-desktop
    kubectl config delete-context draks2
    kubectl config delete-cluster draks2
    kubectl config unset users.clusterUser_draks2_draks2
See: https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration
  
# Overview of the deployment steps

- Login with the Azure Client
- Select the subscription that you want to create the AKS cluster in
- Make your current working directory in the same location as the this readme file
- Create a resource group and note the azure region you are using
- Customize the following files
  - **cluster-issuer-prod.yaml**: replace the noname@nowhere.com with your e-mail address
  - **jmeter_grafana_ingress-prod.yaml**: replace fqdn of drgrafana.westus2.cloudapp.azure.com with your specific url

## Creating the AKS Cluster
**The following assumes you are the Azure subscription owner.  You may want to exclude the monitoring addon as this must create a service account.**

**New way to create the test rig has just been posted!**
I have created a new PowerShell script that creates the AKS cluster and does all of the work for you!  It's not perfect and you will have to customize the files described in the Overview section.

### New Way to Create AKS Cluster

### Step 1

**CreateTestRig.ps1**
- -tenant < K8S NameSpace > 
- -SubDns < Azure Public IP DNS name label > 
- -AksResourceGroup < Resource Group You already created >
- -AksClusterName < Name of your AKS Cluster >

### Old and Broke Way to Create AKS Cluster

    az aks create --resource-group draks2   --name draks2   --node-count 1  --enable-addons monitoring  --generate-ssh-keys
    az aks get-credentials --name draks2 --resource-group draks2
    kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
    kubectl apply -f helm-rbac.yaml
    helm init --service-account tiller

# Creating the Grafana Ingress
Adapted from: https://docs.microsoft.com/en-us/azure/aks/ingress-tls

## NGINX Ingress Controller

    helm install stable/nginx-ingress `
      --namespace $tenant  `
      --set controller.replicaCount=1 `
      --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux `
      --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux `
      --wait

## Retrieve Public IP from NGINX

    $nginxPublicIP = $(kubectl -n $tenant get service -o json|convertfrom-json).items.status.LoadBalancer.ingress.ip
    $SubDns="drgrafana"
    $AksVmResourceGroup="Name of your aks resource group"
    $PUBLICIPID=$(az network public-ip list --resource-group $AksVmResourceGroup --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[ id]" --output tsv)
    az network public-ip update --ids $PUBLICIPID --dns-name $SubDns

## Cluster Certificate Manager

    kubectl create namespace cert-manager
    kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
    # Install the CustomResourceDefinition resources separately 
    kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml 
    helm repo update
    # Install the cert-manager Helm chart
    helm install `
        --name cert-manager `
        --namespace cert-manager `
        --version v0.8.0 jetstack/cert-manager `
        --wait

## CA Cluster Issuer

    # edit the e-mail address replacing with your actual e-mail
    kubectl apply -f cluster-issuer-prod.yaml

## Deploy Grafana

    kubectl -n $tenant apply -f .\jmeter_grafana_deploy.yaml

## Create Ingress Route
    kubectl -n $tenant apply -f .\jmeter_grafana_ingress-prod.yaml

# Scripts

## Building the Docker Images
**File Name:** builddocker.ps1
Must be hand edited to point this to your Docker repository and then update the relevent scripts which is beyond the scope of this document.

## Creating the K8S JMeter Cluster
**File Name:** jmeter_cluster_create.ps1
This will create 1 JMeter Master pod and 2 or more JMeter Slave pods.  It also creates the K8S master configurtion map and the JMeter Slaves service.  Once the script is completed you can check the status of the Pods with the following kubectl command:

**kubectl -n \<K8S NameSpace\> get pods**

- -tenant < K8S NameSpace> 
  - Will create a K8S NameSpace and use that to create and deploy all services
- -ScaleSlaves [integer larger than 2]
  - OPTIONAL parameter which allows for a cluster larger than the default of 1 master and 2 slaves
  
## Running the Test
**File Name:** run_test.ps1
- -tenant (required): K8S NameSpace
- -TestName (required): full or relative path to the JMeter test script
- -ReportFolder (required): folder name to publish the results of the test
- -DeleteTestRig (optional)
  - $true (default) means to remove the JMeter Master and Slave pods at the end of the run.
  - $false means to leave the AKS JMeter Master and slaves.  This is used for debugging purposes.
- -UserProperties (optional): path to a custom user properties file for the JMeter Master pod
- -RedisScript (optional): full or relative path to a Redis script for populating parameters to support perf tests
  - JMeter supports Redis as a data source for parameters.
  - See: https://jmeter-plugins.org/wiki/RedisDataSet/ 
- -GlobalJmeterParams (optional): JMeter supports global parameters by adding -GParameterName=Some Value which will be set as a parameter on the test rig master and slaves
  - This feature allows for any number of "-G" parameters to be added.
  - This feature also allows you to add any other JMeter option you want to assuming it's not already present.  
  - See: https://jmeter.apache.org/usermanual/remote-test.html

## Cleaning Up

To delete tbe cluster you run the following command:
**kubectl delete namespace NAMESPCENAME**

# Supporting files

- Docker Files
  - jmeterbase-docker
    - Creates a JMeter docker base image which is used to create the Master and Slave Docker images
  - jmetermaster-docker
    - Creates the JMeter master docker image
  - jmeterslave-docker
    - Creates the JMeter slave docker image
- K8S files
  - jmeter_master_configmap.yaml
    - configures the entry point for the JMeter master to enumerate the slave pods
  - jmeter_master_deploy.yaml
    - K8S master pod definition
  - jmeter_slaves_deploy.yaml  
    - K8S slave(s) pod definition                                           
  - jmeter_slaves_svc.yaml
    - K8S service which, among other things, allows the jmeter_master_configmap to enumerate the slave pods
- Miscellaneous
  - load_test_run
    - the linux shell script used to execute the tests
    - CRITICAL NOTE:  must be in linux line endings and not DOS                                                      

# References
- https://kubernauts.io/en/
- http://www.testautomationguru.com/jmeter-distributed-load-testing-using-docker/
- https://www.blazemeter.com/blog/make-use-of-docker-with-jmeter-learn-how 
- https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-public-ip-address#create-a-public-ip-address