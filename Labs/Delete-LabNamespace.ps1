[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('1','2', '3', '4', '5a', '5b', '6')]
    [string]
    $Module
)

$namespace = "lab-module-$Module"

kubectl delete ns $namespace --now --ignore-not-found