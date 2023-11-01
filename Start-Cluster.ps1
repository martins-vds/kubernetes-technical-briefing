$AKS_RESOURCE_GROUP="k8s-tech-brief-rg"
$AKS_NAME="ktb-aks"

Write-Host "Starting AKS cluster $AKS_NAME in resource group $AKS_RESOURCE_GROUP..." -ForegroundColor Cyan

az aks start --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP | Out-Null

Write-Host "Redirecting port 5252 to the clusterinfo service..." -ForegroundColor Cyan

Start-Process kubectl -ArgumentList @( "port-forward", "svc/clusterinfo", "5252:5252", "-n", "clusterinfo" ) -WindowStyle Minimized

Write-Host "Launching browser to http://localhost:5252..." -ForegroundColor Cyan

Start-Process http://localhost:5252