[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('1','2', '3', '4', '5a', '5b', '6')]
    [string]
    $Module
)

$namespace = "lab-module-$Module"

kubectl create namespace $namespace -o yaml --dry-run=client | kubectl apply -f -
kubectl config set-context --current --namespace=$namespace