# Overview
There are a lot of docker and k8s based JMeter projects that I was able to find.  The challenge for me was to have a basic test rig without the addon features.  I'm new to K8S and it seems having a lot of features for K8S projects is a core theme.

## Goals
- Learn how to create a JMeter test rig using Docker
- Create a K8S JMeter cluster to conduct performance tests in Azure for customers
- Assume a Windows 10 user
  - Creation and launching of the test rig with PowerShell
  - Take the test, run it and produce a report at the end
- Fully support AKS (Azure Kubernetes Service)
- Build the cluster from Docker root containers

## Dependendies
- Docker for Windwos Desktop: https://docs.docker.com/docker-for-windows/install/
- Kitematic: https://github.com/docker/kitematic
- AKS: https://azure.microsoft.com/en-us/services/kubernetes-service/
- To create a basic load test
  - JmMter 5.x: https://jmeter.apache.org/download_jmeter.cgi
  - JMeter Plugins: https://jmeter-plugins.org/
  - A web site somewhere that you can break and not get in trouble.  :)


## Scripts

1. builddocker.ps1
2. jmeter_cluster_create.ps1
3. run_test.ps1
4. kubectl delete namespace NAMESPCENAME