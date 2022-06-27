##########################################
# Finishing Up                           #
##########################################

# Stop Minikube but keep the VM & data intact (https://minikube.sigs.k8s.io/docs/commands/stop/)
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Stop the Minikube Cluster?" 
$message = "Would you like to stop the minikube cluster?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    # Stop the minikube cluster.
    minikube stop
  }
}

##########################################
# Complete Removal (Optional)            #
##########################################

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Delete Minikube Cluster?" 
$message = "Would you like to delete the whole minikube cluster, including TAP?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    # Delete the minikube cluster and everything it contains, including TAP.
    minikube delete
  }
}

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$title = "Delete Tanzu CLI?" 
$message = "Would you like to delete the Tanzu CLI? (Requires Admin PowerShell)"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    # Remove Tanzu CLI
    rmdir -Recurse "C:\Program Files\tanzu" # Needs admin 
  }
}