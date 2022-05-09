#!/bin/bash

################################################################
# Hosts must be edited to contan your App URls and Minikube IP #
# Minikube Tunnel MUST be running to access your apps!         #
################################################################

# Source common functions & variables
source ./helper.sh

# Describe the stage
title "Stage 2 - Starting Your Kubernetes Cluster." 

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
yes_or_no "Start Minikube profile ${WHITE}${MINIKUBE_PROFILE}${YELLOW} with the ${WHITE}${MINIKUBE_VM_DRIVER}${YELLOW} driver?" \
  && minikube start --kubernetes-version=${KUBERNETES_VERSION} --memory=${MINIKUBE_MEM} --cpus=${MINIKUBE_CPUS} --disk-size=${MINIKUBE_DISK} --driver=${MINIKUBE_VM_DRIVER} -p ${MINIKUBE_PROFILE}

# Starting the Minikube Tunnel
# message "Minikube Tunnel is required so that you can access LoadBalancer services."
# yes_or_no "Start the Minikube Tunnel (needs sudo)?" \
#   && alert "WARNING: You must leave the Minikube Tunnel running in this terminal!" \
#   && minikube tunnel -p ${MINIKUBE_PROFILE}
