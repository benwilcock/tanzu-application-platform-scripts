################################################################
# Test the Developer workload on TAP                           #
# Requires `minikube tunnel` AND Edits to your `hosts` file.   #
# See 'stage-01.ps1' for details.                              #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 7 - Test the Developer Workload on TAP" 
$message = "This script test the developer worload you added to TAP. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# List all the workloads and their status
tanzu apps workload list 

# Get all the workload details inc. status and url
tanzu apps workload get tanzu-java-web-app 

# Test the application is responding (may take a few seconds at first)
curl.exe http://tanzu-java-web-app.default.apps.made-up-name.net 

Write-Host "You should see `Greetings from Spring Boot + Tanzu!` if everything worked." -ForegroundColor DarkGreen -BackgroundColor Black
Write-Host "Congratulations. TAP is installed and running workloads!" -ForegroundColor DarkGreen -BackgroundColor Black