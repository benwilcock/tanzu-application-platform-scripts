################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################

# Ask for permission to proceed.
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 9 - Update the Tanzu Application Platform" 
$message = "This script updates Tanzu Application Platform version $env:TAP_VERSION. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# Load the ENVIRONMENT VARIABLES
. .\settings.ps1

# Load the SECRET VARIABLES
. .\secret-$Env:REPOSITORY_TYPE-tap-env.ps1

# Remove the old tap-values files
rm -Force tap-values.yml, template-tap-values.yml

# Download the template tap-values file
curl.exe -o template-tap-values.yml https://raw.githubusercontent.com/benwilcock/TAPonLAP/main/TAPonLAPv1.1/template-tap-values-win.yml

# Create a new tap-values.yml file using the template
gc template-tap-values.yml | foreach { [Environment]::ExpandEnvironmentVariables($_) } | sc tap-values.yml

# Add a secret for the TAP image registry (required to install)
tanzu secret registry add tap-registry `
  --username $env:INSTALL_REGISTRY_USERNAME `
  --password $env:INSTALL_REGISTRY_PASSWORD `
  --server $env:INSTALL_REGISTRY_HOSTNAME `
  --namespace $env:TAP_NAMESPACE `
  --export-to-all-namespaces `
  --yes 

# Add a package repository record for the TAP image registry (required to install)
tanzu package repository add tanzu-tap-repository `
  --url $env:INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$env:TAP_VERSION `
  --namespace $env:TAP_NAMESPACE 

# Install the TAP packages to Kubernetes
Write-Host "This may take 30 mins or more and use lots of compute and network resources. Go grap a coffee!" -ForegroundColor DarkGreen -BackgroundColor Black
tanzu package installed update tap -p tap.tanzu.vmware.com -v $env:TAP_VERSION `
  --values-file tap-values.yml `
  --poll-timeout 45m `
  --namespace $env:TAP_NAMESPACE

# Remove the values files
#rm -Force tap-values.yml, template-tap-values.yml

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Watch the Installation of TAP" 
$message = "Would you like to watch the installation of TAP as it progresses?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    while (1) {clear; tanzu package installed list -A; Write-Host "When ALL packages have a STATUS of 'Reconcile Succeeded', press Ctrl-C and run the stage-5 script." -ForegroundColor DarkGreen -BackgroundColor Black; sleep 10}
  }
  1{
    Exit
  }
}