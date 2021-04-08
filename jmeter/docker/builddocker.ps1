[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]
    $label="test"
)
docker build --tag="shadowpic/jmeter-base:$label" -f jmeterbase-docker .
docker push "shadowpic/jmeter-base:$label"
docker build --tag="shadowpic/jmeter-master:$label" -f jmetermaster-docker .
docker build --tag="shadowpic/jmeter-slave:$label" -f jmeterslave-docker .
docker push "shadowpic/jmeter-master:$label"
docker push "shadowpic/jmeter-slave:$label"
