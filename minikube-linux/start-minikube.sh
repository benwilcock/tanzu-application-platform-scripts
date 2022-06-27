#!/bin/bash

################################################################
# Hosts must be edited to contan your App URls and Minikube IP #
# Minikube Tunnel MUST be running to access your apps!         #
################################################################

# Source common functions & variables
source ./helper.sh

# List all known profiles
minikube profile list

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
yes_or_no "(Re)Start the Minikube profile ${WHITE}${MINIKUBE_PROFILE}${YELLOW}?" \
  && minikube start --kubernetes-version=${KUBERNETES_VERSION} --memory=${MINIKUBE_MEM} --cpus=${MINIKUBE_CPUS} --disk-size=${MINIKUBE_DISK} --driver=${MINIKUBE_VM_DRIVER} -p ${MINIKUBE_PROFILE}

get_and_set_minikube_ip

./guis-file.sh