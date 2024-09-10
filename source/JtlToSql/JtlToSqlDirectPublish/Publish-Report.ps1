#Requires -Version 7
param(
    [Parameter(Mandatory=$true)]
    [JtlFile("file")]
    [string]$JtlFile,
    [Parameter(Mandatory=$true)]
    [string]$SQLConnectionString,
    [Parameter(Mandatory=$true)]
    [string]$TestPlanName="Always have one",
    [Parameter(Mandatory=$false)]
    [string]$TestRunName
)
if(-not $TestRunName){
	$TestRunName ="TestRun $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss tt")) $((get-timezone).StandardName)"
}

#if the application is not in the current directory do not run it
if(-not (Test-Path ".\JtlToSqlDirectPublish.exe")){
	Write-Host "JtlToSqlDirectPublish.exe not found in the current directory"
	exit 1
}

.\JtlToSqlDirectPublish.exe --jtl $JtlFile --connectionstring $SQLConnectionString --plan $TestPlanName --run $TestRunName
