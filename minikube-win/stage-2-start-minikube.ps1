################################################################
# Minikube requires a DEDICATED *Admin* PowerShell Window      #
# Hosts must be edited to contan your App URls and Minikube IP #
# Minikube Tunnel MUST be running to access your apps!         #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 2 - Starting Minikube" 
$message = "This script starts Minikube, shows the Minikube IP, and opens your hosts file for editing in Notepad. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
minikube start --kubernetes-version='1.22.8' --cpus='8' --memory='12g' --driver='hyperv' 

# Add a host entry for each app behind the tunnel (Windows 8 - 10)
# When Notepad opens, add to the hosts file...
# <your.minikube.ip.address> tap-gui.example.com tanzu-java-web-app.default.apps.example.com
# Find the IP address for Minikube
$env:minikubeip = minikube ip
Write-Host "Next, I'll open your hosts file in Notepad so you can add the following line:" -ForegroundColor DarkGreen -BackgroundColor Black
Write-Host "$env:minikubeip tanzu-java-web-app.default.apps.example.com" -ForegroundColor Blue -BackgroundColor Black
Write-Host "Don't forget to save the file after you've edited it!" -ForegroundColor DarkGreen -BackgroundColor Black


# Opening the hosts file in Notepad as Admin user...
Start-Process notepad -Verb runas "c:\Windows\System32\Drivers\etc\hosts"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Starting Minikube Tunnel" 
$message = "After Minikube Tunnel has started, you must leave this command running. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    # Start the Minikube tunnel (needs admin, or there may be errors) 
    minikube tunnel
  }
}
