################################################################
# Minikube requires a DEDICATED *Admin* PowerShell Window      #
# Hosts must be edited to contan your App URls and Minikube IP #
# Minikube Tunnel MUST be running to access your apps!         #
################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Exiting" ; return 1 ;;
        esac
    done
}

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
echo -e "${BLUE}Stage 2 - Setup Your Minikube Cluster${NC}" 
yes_or_no "$( echo -e ${GREEN}"Starting Minikube for you. OK?"${NC})" \
  && minikube start --kubernetes-version='1.22.6' --cpus='8' --driver=docker

sleep 3
# Adding the host entries to the hosts file (needs sudo)
export ENVOY="$(minikube ip)"
echo -e "${WHITE}Your Minikube IP is ${ENVOY}.${NC}"
export HOSTS="tap-gui.made-up-name.net tanzu-java-web-app.default.apps.made-up-name.net"
echo -e "${GREEN}You need to add '${ENVOY} ${HOSTS}' to your /etc/hosts file${NC}"
echo ${ENVOY} ${HOSTS} | xclip -selection c
yes_or_no "$( echo -e ${WHITE}"Opening /etc/hosts for you in Nano (needs sudo). Use Ctrl+Shift+V to add the new line. Ctrl-X to exit Nano. OK?"${NC})" \
  && sudo nano /etc/hosts

sleep 3
# Starting the Minikube Tunnel
echo -e "${GREEN}Starting Minikube Tunnel.${NC}"
yes_or_no "$( echo -e ${WHITE}"You must leave this terminal running. Continue?"${NC})" \
  && minikube tunnel
