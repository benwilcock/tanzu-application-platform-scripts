# Load the ENVIRONMENT VARIABLES
. .\settings.ps1
. .\secrets.ps1

# Login to Kubernetes on VSphere
kubectl vsphere login --insecure-skip-tls-verify `
 --server=$env:VSPHERE_SERVER `
 -u $env:VSPHERE_USER `
 --tanzu-kubernetes-cluster-name $env:TARGET_CLUSTER

 # Set the target cluster as the Kubenetes context
 kubectx $env:TARGET_CLUSTER

 # Set the namespace to the developer namespace
 kubens $env:TAP_DEV_NAMESPACE

 #start chrome $env:TAP_GUI_URL