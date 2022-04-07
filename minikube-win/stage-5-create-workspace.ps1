################################################################
# Creating a Developer workspace on Kubernetes & TAP           #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 5 - Create a Developer Workspace" 
$message = "This script creates a developer workspace for you on TAP and adds your registry-credentials for $Env:REPOSITORY_TYPE. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# Load the ENVIRONMENT VARIABLES
. .\settings.ps1

# Load the SECRETS for the chosen REPO type
. .\secret-$Env:REPOSITORY_TYPE-tap-env.ps1

# Create a namespace for the developer to work in 
kubectl create ns $env:TAP_DEV_NAMESPACE 

# Add the secret for the BUILD Container Registry 
tanzu secret registry add registry-credentials `
  --server $env:DOCKER_SERVER `
  --username $env:DOCKER_USERNAME `
  --password $env:DOCKER_PASSWORD `
  --namespace $env:TAP_DEV_NAMESPACE 

# Download the service accounts file 
curl.exe -o serviceaccounts.yml https://raw.githubusercontent.com/benwilcock/TAPonLAP/main/TAPonLAPv1.1/serviceaccounts.yml 

# Add the necessary RBAC Roles, Accounts, Bindings etc... 
kubectl --namespace $env:TAP_DEV_NAMESPACE apply -f "serviceaccounts.yml" 

Write-Host "Next, run the stage-6 script." -ForegroundColor DarkGreen -BackgroundColor Black