# Load the ENVIRONMENT VARIABLES
. .\settings.ps1
. .\secrets.ps1


kubectl vsphere login --insecure-skip-tls-verify `
 --server=$env:VSPHERE_SERVER `
 -u $env:VSPHERE_USER `
 --tanzu-kubernetes-cluster-name $env:TARGET_CLUSTER

 kubectx $env:TARGET_CLUSTER

 kubens $env:TAP_DEV_NAMESPACE

 #start chrome $env:TAP_GUI_URL