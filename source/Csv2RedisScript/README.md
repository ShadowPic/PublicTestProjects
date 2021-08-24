 # Csv2RedisScript Solution
 NetCore 3.1 console application responsible for analyzing a Jmeter test file and replace the CSV configuration elements with Redis configuration elements in preparation for running the test on a test rig. This is intended to be hosted inside a Linux based Kubernetes pod.

 The application will generate 2 files:
 1. YourJmeterTest-modified.jmx
 2. csv2redis.redis

 # Running the solution 
 The solution requires you provide particular command line arguments 

 - t, testscript (required) : Your jmeter script containing csv config elements
 - AddBackEndListener(optional) : Whether or not to add influx db backend listener

# Csv2Redis.ps1

The Csv2Redis.ps1 script provides a highly flexible method to execute convert a jmeter script containing CSV configuration to Redis configuration and store in a report folder locally. the script allows you to execute the Csv2Redis executable on a AKS cluster.

 - Tenant (required) : K8S NameSpace
 - TestScript(required) : JMX test script with CSV configuration to convert to Redis configuration
 - ContainerName (required): The name of your Azure Container

 After running this script, you are provided with a csv2redis.redis which you can use as an argument when running run_test.ps1.



