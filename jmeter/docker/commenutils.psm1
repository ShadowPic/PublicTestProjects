function VerifyKubeCtl
{
    if ($null -eq (Get-Command "kubectl.exe" -ErrorAction SilentlyContinue)) 
    { 
        Write-Host "Unable to find kubectl.exe in your PATH"
        throw "kubectl is required"
    }
}

function VerifyHelm3
{
    Write-Output "Verifying Helm v3.* is installed"

    if(($null -eq (Get-Command "helm.exe" -ErrorAction SilentlyContinue)) -and ($null -ne ($testHelm=helm version |Select-String -Pattern "v3.")))
    {
        Write-Host "Wrong version or Helm does not exist"
        throw "helm is not right"
    }

}

function IsJmeterHelmDeployed($tenant)
{
    
    [string]$deploymentStatus=Helm status jmeter --namespace jmeter
    [boolean]$match = $deploymentStatus -like "*STATUS: deployed*"
    return $match 
}