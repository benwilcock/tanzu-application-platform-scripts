################################################################
# Deploy (Run) a Developer workload on TAP                    #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 6 - Run A Developer Workload on TAP" 
$message = "This script runs a developer worload for you on TAP. Continue?"
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

# Observe the workload being built
tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp 

Write-Host "Next, run the stage-6.ps1 script." -ForegroundColor DarkGreen -BackgroundColor Black
