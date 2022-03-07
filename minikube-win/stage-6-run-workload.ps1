################################################################
# Deploy (Run) a Developer workload on TAP                    #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 6 - Run A Developer Workload on TAP" 
$message = "This script creates a developer workload for you on TAP. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# Set the developer namespace environment variable
$Env:TAP_DEV_NAMESPACE = "default" 

# Schedule a workload to run - this may take several minutes
tanzu apps workload create tanzu-java-web-app `
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app `
  --git-branch main `
  --type web `
  --label app.kubernetes.io/part-of=tanzu-java-web-app `
  --label tanzu.app.live.view=true `
  --label tanzu.app.live.view.application.name=tanzu-java-web-app `
  --namespace $env:TAP_DEV_NAMESPACE `
  --yes 


$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Watch the Workload be made Ready" 
$message = "Would you like to watch the workload being compiled, containerized and made 'Ready' by TAP?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    while (1) {clear; tanzu apps workload get tanzu-java-web-app; Write-Host "Wait for the workload to become 'Ready' and be assigned a URL, then press Ctrl-C and run the stage-7 script." -ForegroundColor DarkGreen -BackgroundColor Black; sleep 10}  
  }
}
