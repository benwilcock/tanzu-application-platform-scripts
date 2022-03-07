################################################################
# Requires a DEDICATED *Admin* PowerShell Window               #
# Adds Tanzu CLI executable to "Programs Files"                #
# You only need to do this if you don't have Tanzu CLI already #
################################################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stage 2 - Installing the Tanzu CLI" 
$message = "This script installs the Tanzu CLI from the ZIP you downloaded to your Downloads directory and installs the Tanzu CLI plugins required by TAP. If you already have the correct Tanzu CLI and plugins installed you can skip this step. Continue?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  1{
    Exit
  }
}

# Move to the downloads directory
cd "C:\Users\$env:USERNAME\Downloads\"

# Extract the zip
Expand-Archive .\tanzu-framework-windows-amd64.zip 

# Move to the extracted Tanzu CLI directory
cd tanzu-framework-windows-amd64 

# Create a new home for the Tanzu CLI in "Program Files"
mkdir "C:\Program Files\tanzu" 

# Copy the Tanzu CLI tool to Program Files
cp "cli\core\v0.11.1\tanzu-core-windows_amd64.exe" "C:\Program Files\tanzu\tanzu.exe" 

# Check the Tanzu CLI Tool is on the path and working correctly
tanzu version

# Get ready to add plugins to the tool
$Env:TANZU_CLI_NO_INIT = "true" 

# Install the Plugins required to install TAP
tanzu plugin install --local cli all 

# List the Plugins, checking that package, secret, apps, services, and accelerator are available to you.
tanzu plugin list

Write-Host "Check above that package, secret, apps, services, and accelerator plugins are all available to you." -ForegroundColor DarkGreen -BackgroundColor Black
Write-Host "Next, run the stage-3 script." -ForegroundColor DarkGreen -BackgroundColor Black
