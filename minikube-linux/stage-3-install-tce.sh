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
sub_title "This script installs components required by TAP. If you use TKG v1.5.1 or later you can skip this step."

function install_tce {

    # This variable is needed by the installer to specify the VMware Cluster Essentials for Tanzu bundle
    export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
  
    # Check the download is ready
    TCE_FILE=tanzu-cluster-essentials-linux-amd64-1.0.0.tgz
    check_file $TCE_FILE

    mkdir tanzu-cluster-essentials
    tar -xvf $TCE_FILE -C ./tanzu-cluster-essentials
    prompt "Installing Tanzu Cluster Essentials into the cluster..."
    cd tanzu-cluster-essentials
    ./install.sh

    # Tidy up the extracted folder
    cd ..
    rm -rf ./tanzu-cluster-essentials
}


# TAP Needs with Kubernetes  1.20, 1.21, or 1.22
yes_or_no "Install VMware Cluster Essentials for Tanzu?" \
  && install_tce

# Watch the installation
watch --color "kubectl get pods --all-namespaces; echo -e '${GREEN}If all pods have a STATUS of Running, press Ctrl-C to exit and run the stage-4 script.${NC}'"
