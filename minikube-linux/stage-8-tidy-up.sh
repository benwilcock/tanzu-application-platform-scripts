#!/bin/bash

##########################################
# Finishing Up                           #
##########################################

# Source the environment variables
source ./helper.sh

echo -e "${BLUE}Stage 8 - Tidy Up${NC}" 

# Stop Minikube but keep the VM & data intact (https://minikube.sigs.k8s.io/docs/commands/stop/)
yes_or_no "$( echo -e ${GREEN}"Would you like to stop the minikube cluster, including TAP?"${NC})" \
  && minikube stop \
  && echo -e "${RED}WARNING:${NC} Don't forget to stop the Minikube Tunnel!" 

##########################################
# Complete Removal (Optional)            #
##########################################

# Delete the minikube cluster and everything it contains, including TAP.
yes_or_no "$( echo -e ${GREEN}"Would you like to delete the Minikube cluster, including TAP?"${NC})" \
  && minikube delete

# Remove Tanzu CLI
yes_or_quit "$( echo -e ${GREEN}"Would you like to delete the Tanzu CLI? (needs sudo)?"${NC})" 

# Uninstall the old Tanzu Command Line
sudo rm /usr/local/bin/tanzu  # Remove CLI binary (executable)
rm -rf $HOME/tanzu/cli        # Remove previously downloaded cli files
rm -rf $HOME/.config/tanzu/       # current location # Remove config directory
rm -rf $HOME/.tanzu/              # old location # Remove config directory
rm -rf $HOME/.cache/tanzu         # remove cached catalog.yaml
rm -rf $HOME/Library/Application\ Support/tanzu-cli/* # Remove plug-ins
