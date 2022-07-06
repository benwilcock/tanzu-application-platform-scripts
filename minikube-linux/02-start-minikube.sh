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
  
get_and_set_minikube_ip

echo -en ${DING}