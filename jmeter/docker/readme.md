# Overview
This project is a very lean implementation of a Kubernetes JMeter cluster.  It will allow for the execution of a JMeter test script on an arbitrarily sized [JMeter test rig](https://jmeter.apache.org/usermanual/jmeter_distributed_testing_step_by_step.html#distributed-testing) and then will generate:
- A deployed AKS cluster using managed identities.  The AKS cluster is intended to remain running to provide reporting across performance test runs.
  - The initial size of the cluster is a [single node](https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads#nodes-and-node-pools) with 2 cores.  To successfully run a test with the smallest test rig requires 3 nodes.
  - To increase or decrease the number of nodes you will need to use the [az aks scale](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az_aks_scale) command to a minimum of 3 nodes *assuming* you did not override the nodeVMSize when you run the CreateTestRig PowerShell command.
  - When the test rig is not actively being used to execute tests you can scale it back down to a single node using the [az aks scale](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az_aks_scale) command.
- A [JMeter DashBoard Report](http://jmeter.apache.org/usermanual/generating-dashboard.html#generation)
- [JMeter Test Log \(JTL\)](https://jmeter.apache.org/usermanual/get-started.html#non_gui)
   
## Features
- Certified on [AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/)
- PowerShell scripts automate all of the features 
  - All samples that I found assumed a Linux client and no PoserShell
  - Linux based containers whicdh allow for K8S native pod clustering
- PowerShell script to create your own docker images if you don't want to use mine at https://cloud.docker.com/u/shadowpic
- Build the cluster from Docker root containers
- Real time monitoring of the performance test with Grafana
  - An example Grafana JMeter dashboard is included for import with the [JMeter Demo Dashboard-for external.json](./JMeter%20Demo%20Dashboard-for%20external.json) file.
  - Requires that you add the [JMeter Backend Listener](https://jmeter.apache.org/usermanual/component_reference.html#Backend_Listener).  There is an example of how to use this in the [drparts](../drparts.jmx) sample.
- Combine Azure PAS service metrics side by side with JMeter metrics using Grafana
- Redis support to feed parameters to your tests
  - Redis files supported by feeding the direct redis file as a parameter or using csv2redis.ps1 to convert a CSV to Redis file and using generated Redis file

## Dependencies
- Docker for Windwos Desktop: https://docs.docker.com/docker-for-windows/install/
- Azure Client: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
- AKS: https://azure.microsoft.com/en-us/services/kubernetes-service/
- Helm version v3.2.4: https://github.com/helm/helm/releases/tag/v3.2.4 

To create a basic load test
- JMeter 5.x: https://jmeter.apache.org/download_jmeter.cgi
- JMeter Plugins: https://jmeter-plugins.org/
- A web site somewhere that you can break and not get in trouble.  :)

# Overview of the deployment steps
1. Clone this repo
2. Login with the Azure Client with an account that has sufficient authority to create a new AKS cluster
3. Select the subscription that you want to create the AKS cluster in
    - use the [az account set](https://docs.microsoft.com/en-us/cli/azure/account?view=azure-cli-latest#az_account_set) command
4. Make your current working directory in the same location as the this readme file
5. Create a resource group and note the azure region you are using with the [az group create](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az_group_create) or through https://portal.azure.com/ 
6. Execute the [CreateTestRig.ps1](readme.md#creating-the-aks-cluster) Powershell command.
    - this can fail for a number of reasons with the most common being:
      - not having the correct [dependencies](readme.md#Dependencies) deployed to the machine you are executing the scripts on
      - not having sufficient priveleges to create the test rig
    - If you need to start over there is a [DeleteTestRig](readme.md#if-you-want-to-remove-your-aks-cluster) script
7. At this point if everything has completed successfully you *should* have a working test rig.  Next let's make sure.
8. When executing performance tests you will ALWAYS be using the [jmeter_cluster_create.ps1](jmeter_cluster_create.ps1) followed by the [run_test.ps1](run_test.ps1) scripts.
    - jmeter_cluster_create.ps1 creates a number of assets that *could* be used by your test script.  The first time it executes it will take a long time because it always creates resources.  If resources already exist, like the influxdb, you will get a warning but the script will continue.  This is an expected behavior.
    - the run_test.ps1 script uploads your jmx test script, executes the test and returns a report.
9. If everything has gone awesome you are ready to go break my demo site at https://drpartsunlimited.azurewebsites.net/

I recommand the following commands to test your fancy new test rig
```
.\jmeter_cluster_create.ps1 -tenant jmeter
.\run_test.ps1 -tenant jmeter -TestName ..\drparts.jmx -UserProperties ..\user.properties
```

## Creating the AKS Cluster

Execute the following PowerShell
**CreateTestRig.ps1**
- -tenant (required) < K8S [NameSpace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) > 
- -AksResourceGroup (required) < Resource Group You already created >
- -AksClusterName (required) < Name of your AKS Cluster >
- -NodeVmSize (optional) < Standard_F8s >
  - The VM Size relates to the AKS node size for your test rig.
  - see: https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-create

## Creating the K8S JMeter Cluster
**File Name:** jmeter_cluster_create.ps1
This will create 1 JMeter Master pod and 2 or more JMeter Slave pods.  It also creates the K8S master configurtion map and the JMeter Slaves service.  Once the script is completed you can check the status of the Pods with the following kubectl command:
- -tenant < K8S NameSpace> 
  - Will create a K8S NameSpace and use that to create and deploy all services
- -ScaleSlaves [integer larger than 2]
  - OPTIONAL parameter which allows for a cluster larger than the default of 1 master and 2 slaves

## Convert CSV to Redis
**File Name:** csv2Redis.ps1 

**This script has extended help documentation available.**  ps> get-help .\csv2redis.ps1 -detailed

This script allows you to feed in a CSV file and retrieve a Redis file which you can use when running your test. 

- -tenant (required): K8S NameSpace
- -TestScript (required): JMX test script to convert to Redis.  Do not include path name just the jmx file name.
- -CsvAndJmxFilesDir: The folder which contains the test script and the csv files supporting it. This **must** be contained in the docker directory. 

## Running the Test
**File Name:** run_test.ps1

**This script has extended help documentation available.**  ps> get-help .\run_test.ps1 -detailed
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
- -ExecuteOnceOnMaster (optional)
  - Sometimes there is a need to setup test runs and trying to coordinate across several test slaves to only do things 1 time is difficult. This Provides the ability to execute a test script 1 time per test run on the Master Node.
- -PublishResultsToBlobStorage (optional)
  - To enable the ability to do more advanced reporting like with PowerBi you can add this parameter to upload the contents of the results directory to an Azure Blob Storage.
  - **If you override your default test name the new name will become the root folder in the target container blob**
- -StorageAccount (optional)
  - The string name for the storage account you are uploading the results folder to
- -Container (optional)
  - Blob Storage container that you are uploading the results to.
- -GlobalJmeterParams (optional): JMeter supports global parameters by adding -GParameterName=Some Value which will be set as a parameter on the test rig master and slaves
  - This feature allows for any number of "-G" parameters to be added.
  - This feature also allows you to add any other JMeter option you want to assuming it's not already present.  
  - See: https://jmeter.apache.org/usermanual/remote-test.html

## If you want to remove your AKS Cluster

To delete tbe cluster you run the following PowerShell
**DeleteTestRig.ps1**
- -tenant < K8S [NameSpace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) > 
- -AksResourceGroup < Resource Group You already created >
- -AksClusterName < Name of your AKS Cluster >

## Want a more secure test rig?

I have recently updated the deployment model for the test rig to use a helm chart.  All of the supporting PowerShell scripts have been refactored to support this new deployment mechanism.  Among the settings exposed by the Helm chart is the ability to override the docker images used to create the JMeter test rig.  If you want to use a custom container image you will need to update the [values.yaml](./jmetertestrig/values.yaml) to point to your custom jmeter image(s).

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
- https://kubernauts.de/en/home/
- http://www.testautomationguru.com/jmeter-distributed-load-testing-using-docker/
- https://www.blazemeter.com/blog/make-use-of-docker-with-jmeter-learn-how 
- https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-public-ip-address#create-a-public-ip-address