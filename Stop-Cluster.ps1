$AKS_RESOURCE_GROUP="k8s-tech-brief-rg"
$AKS_NAME="ktb-aks"

Write-Host "Stopping AKS cluster $AKS_NAME in resource group $AKS_RESOURCE_GROUP..." -ForegroundColor Yellow

az aks stop --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP | Out-Null

Write-Host "AKS cluster $AKS_NAME in resource group $AKS_RESOURCE_GROUP stopped." -ForegroundColor Green