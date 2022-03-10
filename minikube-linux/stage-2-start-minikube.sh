#!/bin/bash

################################################################
# Minikube requires a DEDICATED *Admin* PowerShell Window      #
# Hosts must be edited to contan your App URls and Minikube IP #
# Minikube Tunnel MUST be running to access your apps!         #
################################################################

echo -e "${BLUE}Stage 2 - Setup Your Minikube Cluster${NC}" 

# Source common functions & variables
source ./helper.sh

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
yes_or_no "$( echo -e ${GREEN}"Starting Minikube. OK?"${NC})" \
  && minikube start --kubernetes-version='1.22.6' --cpus='8' --driver=docker

sleep 3

# Adding the host entries to the hosts file (needs sudo)
export ENVOY="$(minikube ip)"
export HOSTS="tap-gui.made-up-name.net tanzu-java-web-app.default.apps.made-up-name.net"
echo -e "${GREEN}Your Minikube IP is: ${WHITE}${ENVOY}${NC}"
echo -e "${GREEN}You need to add '${ENVOY} ${HOSTS}' to your /etc/hosts file${NC}"
echo ${ENVOY} ${HOSTS} | xclip -selection c
yes_or_no "$( echo -e ${WHITE}"Opening /etc/hosts for you in Nano (needs sudo). Use Ctrl+Shift+V to add the new line. Ctrl-X to exit Nano. OK?"${NC})" \
  && sudo nano /etc/hosts

sleep 3

# Starting the Minikube Tunnel
echo -e "${GREEN}Starting the Minikube Tunnel.${NC}"
yes_or_no "$( echo -e ${WHITE}"You must leave the Minikube Tunnel running for TAP to operate. Continue?"${NC})" \
  && minikube tunnel
