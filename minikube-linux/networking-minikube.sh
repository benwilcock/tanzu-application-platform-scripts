#!/bin/bash


# Set up the environment variables
source ../tap-env.sh

echo "Adding a Developer Namespace and Registry Credentials."
kubectl create ns ${TAP_DEV_NAMESPACE}

# Add Tanzu registry credentials (needed by the build system)
tanzu secret registry add registry-credentials \
--server ${REGISTRY_SERVER} \
--username ${REGISTRY_USERNAME} \
--password ${REGISTRY_PASSWORD} \
--namespace ${TAP_DEV_NAMESPACE}

# Add the service accounts and roles to the developer namespace
kubectl -n ${TAP_DEV_NAMESPACE} create -f "${TAP_INSTALL_DIR}/serviceaccounts.yml"

##############
# Networking
##############

# Add the IP and the domains to your /etc/hosts file:
# sudo nano /etc/hosts
# XXX.XXX.XXX.XXX benwilcock.io tap-gui.benwilcock.io
echo "--------------------------------------------------------------------------------------"
export ENVOY="$(minikube ip)"
export HOSTS="benwilcock.net tap-gui.benwilcock.net learningcenter.benwilcock.net apps.benwilcock.net tanzu-java-web-app.default.apps.benwilcock.net spring-boot-admin.default.apps.benwilcock.net"
echo "Add '${ENVOY} ${HOSTS}' to your /etc/hosts file (shift-ctrl-v in Nano)"
echo ${ENVOY} ${HOSTS} | xclip -selection c
sudo nano /etc/hosts

# echo "${ENVOY} ${HOSTS}" | sudo tee -a /etc/hosts
http tap-gui.benwilcock.net

##########################
# CNRS Wildcard Config
##########################

# cnrs:
#   domain_name: "apps.${ENVOY}.nip.io"

echo "--------------------------------------------------------------------------------------"
echo "Copy these lines to your minikube-tap-values.yml"
echo ""
echo "cnrs:"
echo "  domain_name: \"apps.${ENVOY}.nip.io\""
echo ""
echo "--------------------------------------------------------------------------------------"
echo "Update your TAP configuration with these new values (shift-ctrl-v in Nano)"
echo "apps.${ENVOY}.nip.io" | xclip -selection c
nano minikube-tap-values.yml

# Update the TAP configuration with the learning center wildcard.
tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.1 -n ${TAP_NAMESPACE} \
--values-file "${TAP_INSTALL_DIR}/minikube-linux/minikube-tap-values.yml"

# Start the Minikube Tunnel so that the LoadBalancer Services can start to reconcile
echo "Opening the Minikube Tunnel so that K8s Services can start."
minikube tunnel
