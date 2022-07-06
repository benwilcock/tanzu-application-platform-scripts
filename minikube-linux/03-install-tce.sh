#!/bin/bash

################################################################
# Tanzu Cluster Essentials (TCE) is required inside            #
# Kubernetes for the Tanzu CLI to pass instructions to.        #
# If your Kubernetes already has TCE you can skip this step.   #
################################################################

# Source common functions & variables
source ./helper.sh

# Describe this stage
title "Stage 3 - Install Cluster Essentials for VMware Tanzu." 
message "If you use TKG v1.5.1 or later you can skip this step."

function install_tce {

  prompt "Installing Cluster Essentials for VMware Tanzu into Kubernetes."

  # Check the download is ready  
  check_file ${TCE_FILE}
  mkdir tanzu-cluster-essentials
  tar -xvf ${TCE_FILE} -C ./tanzu-cluster-essentials
  cd tanzu-cluster-essentials
  ./install.sh

  # Tidy up the extracted folder
  cd ..
  rm -rf ./tanzu-cluster-essentials
}

# Install Cluster Essentials for VMware Tanzu?
yes_or_no "Install Cluster Essentials for VMware Tanzu?" \
  && install_tce

echo -en ${DING}