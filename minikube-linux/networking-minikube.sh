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
kubectl -n ${TAP_DEV_NAMESPACE} apply -f "${TAP_INSTALL_DIR}/serviceaccounts.yml"

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

# Start the Minikube Tunnel so that the LoadBalancer Services can start to reconcile
echo "Now activate the `minikube tunnel` so that K8s Services can start..."
