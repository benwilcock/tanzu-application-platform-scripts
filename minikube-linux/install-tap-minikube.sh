#!/bin/bash

source ../tap-env.sh

# Check your env variables have been set
echo $(env | grep -E '(REGISTRY|NAMESPACE|AWS|INSTALL)')

################################
# Perform TAP Install
################################
echo "\nBeginning the TAP install...\n"
sleep 30
tanzu package install tap -p tap.tanzu.vmware.com -v 1.0.1 -n ${TAP_NAMESPACE} \
--values-file "${TAP_INSTALL_DIR}/minikube-linux/minikube-tap-values.yml"

################################
# Add DEVELOPERS Namespace, Secrets, Accounts, etc.
################################

echo "Installation finished. Check for reconciliation once all your containers have started."

# Check for 'Reconcile succeeded' for all components
watch tanzu package installed list -A 