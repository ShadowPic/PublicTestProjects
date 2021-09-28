param(

    [Parameter(Mandatory=$true,HelpMessage="SQL Connection string to the reporting database")]
    [string]$JtlReportingDatabase,
    [Parameter(Mandatory=$true,HelpMessage="Storage account where the results.jtl blob files can be found and are assumed to be in the jmeterresults blob container.")]
    [string]$JtlReportingStorage,
    [Parameter(Mandatory=$true,HelpMessage="Resource group for the ACI instance")]
    [string]$ResourceGroup,
    [Parameter(Mandatory=$true,HelpMessage="Container name")]
    [string]$ContainerName,
    [Parameter(Mandatory=$false,HelpMessage="Docker image name")]
    [string]$ImageName="shadowpic/filejtltosql:latest"
    

)

az container create --resource-group $ResourceGroup --name $ContainerName --image $ImageName --restart-policy OnFailure `
    --environment-variables RunOnceAndStop="true" JtlReportingDatabase="$JtlReportingDatabase" JtlReportingStorage="$JtlReportingStorage"
    

