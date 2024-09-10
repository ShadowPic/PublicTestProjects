#Requires -Version 7
param(
    [Parameter(Mandatory=$true)]
    [string]$JtlFile,
    [Parameter(Mandatory=$true)]
    [string]$SQLConnectionString,
    [Parameter(Mandatory=$true)]
    [string]$TestPlanName="Always have one",
    [Parameter(Mandatory=$false)]
    [string]$TestRunName
)

function GetPrettyDateFormat($timestamp)
{
    $origin=New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $timestamp=$origin.AddSeconds([double]$timestamp/1000)
    return "$((Get-Date -date $timestamp).ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss tt")) $((get-timezone).StandardName)"
    
}

function GetFirstJtlTimeStamp ($JtfFile)
{

	# Import only the first row of the CSV file
	$firstRow = Import-Csv -Path $JtfFile | Select-Object -First 1

	# Retrieve the value of the first column from the first row
	$firstColumnValue = $firstrow.timeStamp

	# Output the value
	return $firstColumnValue
}


if(-not $TestRunName){
	$TestRunName ="TestRun $(GetPrettyDateFormat ( GetFirstJtlTimeStamp $JtlFile))"
}

#if the application is not in the current directory do not run it
if(-not (Test-Path ".\JtlToSqlDirectPublish.exe")){
	Write-Host "JtlToSqlDirectPublish.exe not found in the current directory"
	exit 1
}

.\JtlToSqlDirectPublish.exe --jtl $JtlFile --connectionstring $SQLConnectionString --plan $TestPlanName --run $TestRunName
