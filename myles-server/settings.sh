#!/bin/bash

############## Common Environment Variables #######################

# Specify the name of the VPN that must be active
export VPN_NAME='VMware'

# Specify the Kubernetes namespace to use as your developer workspace.
export TAP_DEV_NAMESPACE="default" 

# Specify the Kubernetes cluster to target.
export TARGET_CLUSTER="tap-ga" 

# Specify the URL to open after connecting 
export TAP_GUI_URL="http://tap-gui.tap.labs.satm.eng.vmware.com/"

