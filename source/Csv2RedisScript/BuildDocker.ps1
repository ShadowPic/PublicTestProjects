#Requires -Version 7 
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]
    $label="test"
)
docker build --tag="shadowpic/csv2redis:$label" .
docker push "shadowpic/csv2redis:$label"