############## Common Environment Variables #######################

# Specify the name of the VPN that must be active
#$env:VPN_NAME='VMware'

# Specify the Kubernetes namespace to use as your developer workspace.
$Env:TAP_DEV_NAMESPACE = "default" 

# Specify the Kubernetes cluster to target.
$Env:TARGET_CLUSTER = "tap-ga" 

# Specify the URL to open after connecting 
$Env:TAP_GUI_URL = "http://tap-gui.tap.labs.satm.eng.vmware.com/"