################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 4 - Install the Tanzu Application Platform (TAP)" 
$message = "This script installs TAP onto Minikube. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# Choose where Built container images will go...
$Env:REPOSITORY_TYPE = "harbor" # One of "dockerhub" "harbor" "local"

# Specify the version of TAP to install
$Env:TAP_VERSION = "1.0.2-build.8" # "1.0.1" 
$Env:TAP_NAMESPACE = "tap-install"
. .\secret-$Env:REPOSITORY_TYPE-tap-env.ps1

# Print the environment variables
dir env:

# Prepare the TAP install to Kubernetes
kubectl create ns $env:TAP_NAMESPACE  

# Add a secret for the TAP image registry (required to install)
tanzu secret registry add tap-registry --username $env:INSTALL_REGISTRY_USERNAME --password $env:INSTALL_REGISTRY_PASSWORD --server $env:INSTALL_REGISTRY_HOSTNAME --export-to-all-namespaces --yes --namespace $env:TAP_NAMESPACE  

# Add a package repository record for the TAP image registry (required to install)
tanzu package repository add tanzu-tap-repository --url $env:INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$env:TAP_VERSION --namespace $env:TAP_NAMESPACE 

sleep 10

# Check you're ready to go and that K8s has all the 'TAP Cluster Essentials' like `kapp-controller` and TAP repositories installed... 
tanzu package repository get tanzu-tap-repository --namespace $env:TAP_NAMESPACE # Has the reconcile succeeded?
tanzu package available list tap.tanzu.vmware.com --namespace $env:TAP_NAMESPACE # Is tap.tanzu.vmware.com in the list?
tanzu package available list --namespace $env:TAP_NAMESPACE # Do you see a big list of all TAP packages and versions?


if ( $Env:REPOSITORY_TYPE -eq "dockerhub" )
{
  Write-Host "DockerHub has user pull limits. You may struggle to install TAP!" -ForegroundColor Red -BackgroundColor Black
}

# Install the TAP packages to Kubernetes
Write-Host "This may take 30 mins or more and use lots of compute and network resources. Go grap a coffee!" -ForegroundColor DarkGreen -BackgroundColor Black
tanzu package install tap -p tap.tanzu.vmware.com -v $env:TAP_VERSION `
  --values-file secret-$Env:REPOSITORY_TYPE-tap-values.yml `
  --namespace $env:TAP_NAMESPACE

while (1) {clear; tanzu package installed list -A; Write-Host "When ALL packages have a STATUS of 'Reconcile Succeeded', press Ctrl-C and run the stage-5.ps1 script." -ForegroundColor DarkGreen -BackgroundColor Black; sleep 10}
