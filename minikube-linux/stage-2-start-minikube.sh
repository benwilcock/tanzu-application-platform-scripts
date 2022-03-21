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
yes_or_no "Start Minikube with the ${WHITE}${MINIKUBE_VM_DRIVER}${YELLOW} driver?" \
  && minikube start --kubernetes-version='1.22.6' --memory='16g' --cpus='8' --driver=${MINIKUBE_VM_DRIVER}

# Adding the host entries to the hosts file (needs sudo)
export ENVOY="$(minikube ip)"
export HOSTS="tap-gui.example.com tanzu-java-web-app.default.apps.example.com"
message "Your Minikube IP is: ${GREEN}${ENVOY}${NC}"
message "You must add ${GREEN}'${ENVOY} ${HOSTS}'${NC} to your '/etc/hosts' file."
message "This will enable http requests to be routed to specific TAP applications."
echo ${ENVOY} ${HOSTS} | xclip -selection c
yes_or_no "Opening /etc/hosts in Nano (needs sudo) for you. Use Ctrl+Shift+V to add the new line. Ctrl-X to exit Nano. Ready?" \
  && sudo nano /etc/hosts

# Starting the Minikube Tunnel
message "Minikube Tunnel is required so that you can access LoadBalancer services."
yes_or_no "Start the Minikube Tunnel (needs sudo)?" \
  && alert "WARNING: You must leave the Minikube Tunnel running in this terminal!" \
  && minikube tunnel
