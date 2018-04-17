Param(
	[parameter(Mandatory=$false)]
	$ProjectFilePath = "C:\Users\USERNAME\Documents\Visual Studio 2017\Projects\ssisDBTest\isp1\bin\Development\isp1.ispac",
	[parameter(Mandatory=$false)]
	$SSISDBServerEndpoint = "AZUREDBINSTANCENAME.database.windows.net"

)
# Variables
$SSISDBServerAdminUserName = "sqladmin"
$SSISDBServerAdminPassword = "REDACTED"
$PackageConnectionStringParam="Data Source=AZUREDBINSTANCENAME.database.windows.net;User ID=sqladmin;Password=REDACTED;Initial Catalog=testdb;Provider=SQLNCLI11.1;Persist Security Info=True;Auto Translate=False;"
$EnvironmentName="test"
$FolderName="isp1.ispac"
$ProjectName="isp1"
$EnvironmentName="test"
$ParameterName="AZUREDBINSTANCENAMEDatabaseWindowsNetTestdbSqladmin1_ConnectionString"
$ParameterValue="Data Source=AZUREDBINSTANCENAME.database.windows.net;User ID=sqladmin;Password=REDACTED;Initial Catalog=testdb;Provider=SQLNCLI11.1;Persist Security Info=True;Auto Translate=False;"
$ParameterDescription="A lovely connection string"
# Load the IntegrationServices Assembly
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;

# Store the IntegrationServices Assembly namespace to avoid typing it every time
$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

Write-Host "Connecting to server ..."

# Create a connection to the server
$sqlConnectionString = "Data Source=" + $SSISDBServerEndpoint + ";User ID="+ $SSISDBServerAdminUserName +";Password="+ $SSISDBServerAdminPassword + ";Initial Catalog=SSISDB"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

# Create the Integration Services object
$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

# Get the catalog
$catalog = $integrationServices.Catalogs['SSISDB']
$folder=$catalog.Folders[$FolderName]
$environment = $folder.Environments[$EnvironmentName]

if (!$environment)
{
    Write-Host "Creating environment ..." 
    $environment = New-Object "$ISNamespace.EnvironmentInfo" ($folder, $EnvironmentName, $EnvironmentName)
    $environment.Create()            
}

$project = $folder.Projects[$ProjectName]
$ref = $project.References[$EnvironmentName, $folder.Name]

if (!$ref)
{
    # making project refer to this environment
    Write-Host "Adding environment reference to project ..."
    $project.References.Add($EnvironmentName, $folder.Name)
    $project.Alter() 
}

$TargetEnvironmentVariable=$environment.Variables[$ParameterName]

if(!$TargetEnvironmentVariable)
{
    Write-Host "Adding environment variable $($ParameterName)" 
    $environment.Variables.Add(
        $ParameterName, 
        [System.TypeCode]::String, $ParameterValue, $false, $ParameterDescription)
    $environment.Alter()
    $TargetEnvironmentVariable = $environment.Variables[$ParameterName];
}

$package = $project.Packages["Package.dtsx"]
$package.Parameters[$ParameterName].Set(
    [Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, 
    $TargetEnvironmentvariable.Name)            
$package.Alter()  