#!/bin/bash

################################################################
#                             #
#  #
################################################################

# Source common functions & variables
source ../helper.sh

# Create a new dummy secret
kubectl create secret generic k8s-reader-overlay --from-file=rbac_overlay.yaml -n tap-install

# Substitute the current environment variables into the template to create a tap-values.yml file
prompt "Prepare a new tap-values.yml file using the current ENVIRONMENT variables."
envsubst < template-tap-values.yml > tap-values.yml

# Check your values before proceeding
yes_or_no "Would you like to view your tap-values.yml file (contains passwords)?" && \
  bat tap-values.yml

yes_or_quit "Update TAP using these values?"
tanzu package installed update tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yml -n $TAP_INSTALL_NAMESPACE