#!/usr/bin/bash

# Set up the environment variables
source ../tap-env.sh

# Check your env variables have been set
echo $(env | grep -E '(REGISTRY|NAMESPACE|AWS|INSTALL)')

# Create a namespace for the TAP installed components
kubectl create ns ${TAP_NAMESPACE} 

# Create a secret for the VMware TAP registry (usually registry.tanzu.vmware.com)
# These credentials are the same as your Tanzu Network credentials!
tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace ${TAP_NAMESPACE}

# Add Tanzu Application Platform package repository to the cluster
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.0.1 \
  --namespace ${TAP_NAMESPACE}

# Check you're ready to go and that K8s has all the 'TAP Cluster Essentials' like `kapp-controller` and TAP repositories installed... 
tanzu package repository get tanzu-tap-repository --namespace ${TAP_NAMESPACE} # Has the reconcile succeeded?
tanzu package available list tap.tanzu.vmware.com --namespace ${TAP_NAMESPACE} # Is tap.tanzu.vmware.com in the list?
tanzu package available list --namespace ${TAP_NAMESPACE} # Do you see a big list of all TAP packages and versions?

# The big TAP install...
echo "\nBeginning the TAP install...\n"
tanzu package install tap -p tap.tanzu.vmware.com -v 1.0.0 -n ${TAP_NAMESPACE} --values-file "${TAP_INSTALL_DIR}/eks/eks-tap-values.yml"
sleep 30

################################
# Add DEVELOPERS Namespace, Secrets, Accounts, etc.
################################

# Add A Developer Namespace and development registry credentials
kubectl create ns ${TAP_DEV_NAMESPACE}

# Add Tanzu registry credentials (needed by the build system)
tanzu secret registry add registry-credentials \
--server ${REGISTRY_SERVER} \
--username ${REGISTRY_USERNAME} \
--password ${REGISTRY_PASSWORD} \
--namespace ${TAP_DEV_NAMESPACE}

# Add the service accounts and roles to the developer namespace
kubectl -n ${TAP_DEV_NAMESPACE} apply -f "${TAP_INSTALL_DIR}/serviceaccounts.yml"
