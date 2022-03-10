#!/bin/bash

################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################

echo -e "${BLUE}Stage 4 - Install the Tanzu Application Platform (TAP)${NC}" 

# Source the environment variables
source ./helper.sh

# Namespace for the TAP installation components
export TAP_NAMESPACE="tap-install"

# Continue with the install?
yes_or_quit "$( echo -e "${GREEN}Install TAP version ${WHITE}${TAP_VERSION}${GREEN} to Kubernetes with your images stored in ${WHITE}${REPOSITORY_TYPE}${GREEN}?${NC}" )"

# Prepare the TAP install to Kubernetes
kubectl create ns $TAP_NAMESPACE  

# Add a secret for the TAP image registry (required to install)
tanzu secret registry add tap-registry \
  --username $INSTALL_REGISTRY_USERNAME \
  --password $INSTALL_REGISTRY_PASSWORD \
  --server $INSTALL_REGISTRY_HOSTNAME \
  --namespace $TAP_NAMESPACE \
  --export-to-all-namespaces \
  --yes 

# Add a package repository record for the TAP image registry (required to install)
tanzu package repository add tanzu-tap-repository \
  --url $INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --namespace $TAP_NAMESPACE 

# Check you're ready to go and that K8s has all the 'TAP Cluster Essentials' like `kapp-controller` and TAP repositories installed... 
# tanzu package repository get tanzu-tap-repository --namespace $TAP_NAMESPACE # Has the reconcile succeeded?
# tanzu package available list tap.tanzu.vmware.com --namespace $TAP_NAMESPACE # Is tap.tanzu.vmware.com in the list?
# tanzu package available list --namespace $TAP_NAMESPACE # Do you see a big list of all TAP packages and versions?

# Install the TAP packages to Kubernetes
echo -e "${BLUE}Installing TAP. This may take 30 mins or more and use lots of compute and network resources. Go grap a coffee!${NC}"
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION \
  --values-file secret-$REPOSITORY_TYPE-tap-values.yml \
  --namespace $TAP_NAMESPACE

# Watch the progress of the installation
yes_or_quit "$( echo -e "${GREEN}Would you like to watch the TAP install progress some more?${NC}" )"
watch --color "tanzu package installed list -A; echo -e '${GREEN}When ALL packages have a STATUS of 'Reconcile Succeeded', press Ctrl-C to exit and run the stage-5 script.${NC}'"
