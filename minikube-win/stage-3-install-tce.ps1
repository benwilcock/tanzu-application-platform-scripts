################################################################
# Cluster Essentials for VMware Tanzu is required inside       #
# Kubernetes for the Tanzu CLI to pass instructions to.        #
# If your Kubernetes already has TCE you can skip this step.   #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 3 - Install Cluster Essentials for VMware Tanzu" 
$message = "This script installs the Cluster Essentials for VMware Tanzu components required by TAP. If you use TKG v1.5.1 or later you can skip this step. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# First, create the required Kubernetes namespaces. 
kubectl create namespace tanzu-cluster-essentials 
kubectl create namespace kapp-controller 
kubectl create namespace secretgen-controller

# Next, apply the YAML configurations for the required apps: 
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.34.0/release.yml -n kapp-controller 
kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.8.0/release.yml -n secretgen-controller 

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Watch the Installation of Cluster Essentials for VMware Tanzu" 
$message = "Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

while (1) {clear; kubectl get pods --all-namespaces; Write-Host "When ALL pods have a STATUS of 'Running', press Ctrl-C and run the stage-4 script." -ForegroundColor DarkGreen -BackgroundColor Black; sleep 10}
