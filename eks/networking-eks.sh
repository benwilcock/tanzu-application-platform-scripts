#!/bin/bash


# Set up the environment variables
source ../tap-env.sh

##############
# Networking
##############

# Add the IP and the domains to your /etc/hosts file:
# sudo nano /etc/hosts
# XXX.XXX.XXX.XXX benwilcock.io tap-gui.benwilcock.io

export ELB_HOST_NAME=$(kubectl get service envoy -n tanzu-system-ingress -o jsonpath='{.status.loadBalancer.ingress[].hostname}')
export ENVOY="$(host ${ELB_HOST_NAME} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)" # get the IP/URL for ingress
export HOSTS="benwilcock.io tap-gui.benwilcock.io"
export APPS_DOMAIN="apps.${ENVOY}.nip.io"
echo ${ENVOY} ${HOSTS} | xclip -selection c
sleep 5
echo "--------------------------------------------------------------------------------------"
echo "Add '${ENVOY} ${HOSTS}' to your /etc/hosts file (shift-ctrl-v in Nano)"
sudo nano /etc/hosts

# echo "${ENVOY} ${HOSTS}" | sudo tee -a /etc/hosts
http tap-gui.benwilcock.io

##########################
# Learningcenter & CNRS Wildcards
##########################

# ************ Manual Step **************
# Edit the learning center wildcard (in ben-eks-values.yml):

# learningcenter:
#   ingressDomain: "learningcenter.${ENVOY}.nip.io"

# cnrs:
#   domain_name: "apps.${ENVOY}.nip.io"

echo "--------------------------------------------------------------------------------------"
echo "Copy these lines to your tap-values.yml"
echo ""
echo "learningcenter:"
echo "  ingressDomain: \"learningcenter.${ENVOY}.nip.io\""
echo ""
echo "cnrs:"
echo "  domain_name: \"apps.${ENVOY}.nip.io\""
echo ""
echo "--------------------------------------------------------------------------------------"

echo "Now update your TAP configuration with the new LC and CNRS wildcard..."
echo ""
echo "tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.0 -n tap-install -f ben-eks-values.yml"

exit 0;

# Update the TAP configuration with the learning center wildcard.
tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.1 -n tap-install -f $TAP_INSTALL_DIR/eks/eks-tap-values.yml

# Updating the learning center (trainingportal) URL:
kubectl describe systemprofile # Check the TAP update above was applied 
kubectl get trainingportals learning-center-guided # Check the current trainingportal value
exit 0
kubectl delete trainingportals learning-center-guided # Delete the old value if required
watch kubectl get trainingportals learning-center-guided # Watch for the new value to appear

