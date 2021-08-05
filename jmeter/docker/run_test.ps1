<#
    .SYNOPSIS
    Executes JMeter performance tests on an AKS cluster.

    .DESCRIPTION
    The run_test.ps1 script provides a highly flexible method to execute JMeter performance scripts.
    It will produce a JMeter dashboard report in a uniquely named folder in the current working directory.
    After the test has completed the JMeter test rig is deleted.

    .PARAMETER Tenant
    Theoretically this allows for multiple concurrent jmeter deployments on a common AKS cluster.  Please note
    that this feature has not been functionally tested yet.

    .PARAMETER TestName
    The name of the JMeter test to be executed.

    .PARAMETER ReportFolder
    A folder name will be automatically created.  You have the option of providing a folder name if desired.

    .PARAMETER DeleteTestRig
    This is used for debugging purposes.  If you want to keep the test rig around so you can inspect the current state of the test rig pods you can.  

    .PARAMETER UserProperties
    If you would like to customize the JMeter dashboard report you can provide a custom user.properties file.  There is an example user.properties file
    in the folder above where these scripts are located.
    
    .PARAMETER RedisScript
    For high performance and scaleable parameters it is recommended to use Redis cache.  

    .PARAMETER ExecuteOnceOnMaster
    Sometimes there is a need to setup test runs and trying to coordinate across several test slaves to only do things 1 time is difficult. This Provides the ability to execute a test script 1 time per test run on the Master Node.
    * You can can initialize stuff and not have to worry about concurrence
    * The same JMX is used to initialize and run the performance test
    * A JMeter command line parameter of -JMaster=true is added so that your JMeter script can use an "If Controller" to modify how it acts on the master node.
    * No slaves start executing until after the JMX script has completed on the Master node.

    .PARAMETER PublishResultsToBlobStorage
    To enable the ability to do more advanced reporting like with PowerBi you can add this parameter to upload the contents of the results directory to an Azure Blob Storage.
    
    .PARAMETER PublishTestToStorageAccount
    This feature includes the test file in the storage account and report folder

    .PARAMETER StorageAccount
    The string name for the storage account you are uploading the results folder to

    .PARAMETER Container
    Blob Storage container that you are uploading the results to.

    .PARAMETER StorageAccountPathTopLevel
    This feature allows the user to specify of the name of the test run report. This name is refected in the Azure Storage Account and Power BI report.
    
    .PARAMETER GlobalJmeterParams
    JMeter supports global parameters by adding -GParameterName=Some Value which will be set as a parameter on the test rig master and slaves.
    * This feature allows for any number of "-G" parameters to be added.
    * This feature also allows you to add any other JMeter option you want to assuming it's not already present.
    
    .INPUTS
    None.  You cannot pipe objects to run_test.ps1

    .EXAMPLE
    PS> .\run_test.ps1 -tenant jmeter -TestName ..\drparts.jmx -UserProperties ..\user.properties

    .LINK 
    JMeter If Controller: https://jmeter.apache.org/usermanual/component_reference.html#If_Controller
    JMeter test Rigs: https://jmeter.apache.org/usermanual/remote-test.html

#>

#Requires -Version 7

param(
    [Parameter(Mandatory=$true)]
    [string]
    $tenant,
    # Name of test
    [Parameter(Mandatory=$true)]
    [string]
    $TestName,
    # Where to put the report directory
    [Parameter(Mandatory=$false)]
    [string]
    $ReportFolder="$(get-date -Format FileDateTimeUniversal -AsUTC)results",
    [Parameter(Mandatory=$false)]
    [bool]
    $DeleteTestRig = $true,
    [Parameter(Mandatory=$false)]
    [string]
    $UserProperties="",
    [Parameter(Mandatory=$false)]
    [string]
    $RedisScript="",
    [Parameter(Mandatory=$false)]
    [Switch]
    $ExecuteOnceOnMaster,
    [Parameter(Mandatory=$false)]
    [Switch]
    $PublishResultsToBlobStorage,
    [Parameter(Mandatory=$false)]
    [switch]
    $PublishTestToStorageAccount,
    [Parameter(Mandatory=$false)]
    [string]
    $PublishPreviousResultsToStorageAccount,
    [Parameter(Mandatory=$false)]
    [string]
    $StorageAccount="",
    [Parameter(Mandatory=$false)]
    [string]
    $Container="",
    [Parameter(Mandatory=$false)]
    [string]
    $StorageAccountPathTopLevel="",
    [parameter(ValueFromRemainingArguments=$true)]
    [string[]]
    $GlobalJmeterParams
)
#$JmeterVersion=5.2.1
$CurrentPath = Split-Path $MyInvocation.MyCommand.Path -Parent

Set-Location $CurrentPath

Import-Module ./commenutils.psm1 -force

if($PublishResultsToBlobStorage.IsPresent)
{
    if(($StorageAccount -eq "") -or ($Container -eq ""))
    {
        Write-Error "If publishing to a storage account the -StorageAccount and -Container are required fields"
        throw "Required fields missing when publishing to storage account"
    }
}

if($null -eq $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name) )
{
    Write-Error "Master pod does not exist"
    exit
}
$MasterPod = $(kubectl -n $tenant get pods --selector=jmeter_mode=master --no-headers=true --output=name).Replace("pod/","")
Write-Output "Checking for user properties"
if(!($UserProperties -eq $null -or $UserProperties -eq "" ))
{
    Write-Output "Copying user.properties over"
    kubectl cp $UserProperties $tenant/${MasterPod}:/jmeter/apache-jmeter-5.3/bin/user.properties
}
Write-Output "Checking for Redis script"
if(!($RedisScript -eq $null -or $RedisScript -eq ""))
{
    #Since we use helm to install Redis we can assume the pod name for the first redis slave instance
    write-output "Executing redis script"
    $redisMaster=GetRedisMaster -tenant $tenant
    Get-Content $RedisScript | kubectl -n $tenant exec -i $redisMaster -- redis-cli --pipe
}
Write-Output "Processing global parameters"
[string]$GlobalParmsCombined=" "
foreach($gr in $GlobalJmeterParams)
{
    $GlobalParmsCombined += $gr + " "

}
Write-Output "Copying test plan to aks"
kubectl cp $(Split-Path $TestName -NoQualifier) $tenant/${MasterPod}:"/$(Split-Path $TestName -Leaf)"
if($ExecuteOnceOnMaster.IsPresent)
{
    Write-Output "Starting optional execution of jmx on the master node"
    kubectl -n $tenant exec $MasterPod -- jmeter -n -t "/$(Split-Path $TestName -Leaf)" -JMaster=true $GlobalJmeterParams
}
Write-Output "Starting test execution on AKS Cluster"

kubectl -n $tenant exec $MasterPod -- /load_test_run "/$(Split-Path $TestName -Leaf)" $GlobalJmeterParams
Write-Output "Retrieving dashboard, results and Master jmeter.log"
kubectl cp $tenant/${MasterPod}:/report $ReportFolder
kubectl cp $tenant/${MasterPod}:/results.log $ReportFolder/results.jtl
kubectl cp $tenant/${MasterPod}:/jmeter/apache-jmeter-5.3/bin/jmeter.log $ReportFolder/jmeter.log

if($PublishResultsToBlobStorage.IsPresent)
{

    # Checking to make sure Azure Client is installed 
    $isAzureClientInstalled=VerifyCommandExists -cmdName az
    if ($isAzureClientInstalled)
    {
         Write-Output "Azure Client found."
    }
    else
    {
        Write-Output "Azure Client not found."
        throw "Azure Client is required to publish results to Azure Storage Account."
    }

    if ($PublishTestToStorageAccount.IsPresent) 
    {
        Copy-Item -Path $TestName -Destination $ReportFolder -Force
    } 

    # Making sure result file created is not empty
    $currentDirectory=Split-Path $myInvocation.MyCommand.Path
    $resultDirectory="$($currentDirectory)/$($ReportFolder)"
    $resultFile=Get-ChildItem -Path $resultDirectory -force | Where-Object Extension -in ('.jtl')
    if ((Get-Content $resultFile).Length -le 1) 
    {
        Write-Output ".jtl file is empty"
        throw "Empty .jtl file found. jtl file with test results is required"
    } 

    # Making sure file does not only include header
    $readFile = New-Object System.IO.StreamReader($resultFile)
    $header=$readFile.ReadLine()
    $firstResultLine=$readFile.ReadLine()
    if ($null -eq $firstResultLine)
    {
        Write-Output ".jtl file has no results."
        throw ".jtl file with test results is required"
    }

    $destinationPath=get-date -format "yyyy/MM/dd" -AsUTC
    #TODO: Add checking to ensure the minimum verson of AZ is installed already
    [xml]$testPlanXml=Get-Content $TestName
    $testPlanName=$testPlanXml.SelectNodes("//TestPlan").testname
    if (!($null -eq $StorageAccountPathTopLevel) -and !($StorageAccountPathTopLevel -eq "")) 
    {
        $destinationPath = $StorageAccountPathTopLevel + "/" + $destinationPath
    }
    elseif (!($testPlanName -eq "Test Plan") -and !($testPlanName -eq "") -and !($null -eq $testPlanName)) 
    {
        $destinationPath = $testPlanName + "/" + $destinationPath
    }
    else 
    {
        $destinationPath = "Test Plan/" + $destinationPath
    }

    Write-Output "Publishing to storage account $StorageAccount to folder $destinationPath"
    Write-Output "Adding the AZ storage-preview extension"
    az extension add --name storage-preview
    Write-Output "Attempting to upload to storage account using the current AZ Security context"
    PublishResultsToStorageAccount -container $Container -StorageAccountName $StorageAccount -DestinationPath $destinationPath -SourceDirectory $ReportFolder
}

if($DeleteTestRig)
{
    $result = .\Set-JmeterTestRig.ps1 -tenant $tenant -ZeroOutTestRig $true
   
}