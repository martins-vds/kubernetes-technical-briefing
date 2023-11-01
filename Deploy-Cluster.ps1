$AKS_RESOURCE_GROUP = "k8s-tech-brief-rg"
$LOCATION = "eastus"
$VM_SKU = "Standard_D2as_v5"
$AKS_NAME = "ktb-aks"
$NODE_COUNT = "3"

$osm_namespace = "osm-system"
$osm_mesh_name = "osm"

az group create --location $LOCATION `
    --resource-group $AKS_RESOURCE_GROUP

az aks create --node-count $NODE_COUNT `
    --generate-ssh-keys `
    --node-vm-size $VM_SKU `
    --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

az aks enable-addons --addons azure-keyvault-secrets-provider `
    --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

az aks get-credentials --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

helm repo add scubakiz https://scubakiz.github.io/clusterinfo/
helm repo add kedacore https://kedacore.github.io/charts
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm repo add chaos-mesh https://charts.chaos-mesh.org

helm repo update

helm install clusterinfo scubakiz/clusterinfo

helm upgrade --install ingress-nginx ingress-nginx `
    --repo https://kubernetes.github.io/ingress-nginx `
    --namespace ingress-nginx --create-namespace `
    --set controller.nodeSelector."kubernetes\.io/os"=linux `
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux `
    --set controller.service.externalTrafficPolicy=Local `
    --set defaultBackend.image.image=defaultbackend-amd64:1.5

helm install vpa fairwinds-stable/vpa `
    --namespace vpa --create-namespace `
    --set admissionController.enabled=false `
    --set recommender.enabled=true `
    --set updater.enabled=false

helm install goldilocks --namespace vpa fairwinds-stable/goldilocks

helm install keda kedacore/keda `
    --create-namespace --namespace keda

osm install `
    --mesh-name "$osm_mesh_name" `
    --osm-namespace "$osm_namespace" `
    --set=osm.enablePermissiveTrafficPolicy=true

helm install chaos-mesh chaos-mesh/chaos-mesh `
    --namespace=chaos-testing --create-namespace `
    --set chaosDaemon.runtime=containerd `
    --set chaosDaemon.socketPath=/run/containerd/containerd.sock
