#!/bin/bash

##########################################
# Finishing Up                           #
##########################################

# Source the environment variables
source ./helper.sh

# Describe the stage
title "Stage 8 - Tidy Up." 

# Remove all workloads?
yes_or_no "Delete all running workloads?" \
  && tanzu apps workload delete --all --yes

# Stop Minikube but keep the VM & data intact (https://minikube.sigs.k8s.io/docs/commands/stop/)
yes_or_no "Stop the minikube cluster (including TAP)?" \
  && minikube stop -p ${MINIKUBE_PROFILE}

##########################################
# Complete Removal (Optional)            #
##########################################

# Delete the minikube cluster and everything it contains, including TAP.
yes_or_no "Delete the Minikube cluster (including TAP)?" \
  && minikube delete -p ${MINIKUBE_PROFILE}

# Remove Tanzu CLI
yes_or_quit "Delete the Tanzu CLI? (as sudo)?" 

# Uninstall the old Tanzu Command Line
sudo rm /usr/local/bin/tanzu  # Remove CLI binary (executable)
rm -rf $HOME/.config/tanzu/       # current location # Remove config directory
rm -rf $HOME/.tanzu/              # old location # Remove config directory
rm -rf $HOME/.cache/tanzu         # remove cached catalog.yaml
rm -rf $HOME/.local/share/tanzu-cli # Remove plug-ins
