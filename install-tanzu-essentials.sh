#!/bin/bash

##################################
# Install Tanzu Cluster Essentials
##################################

# Set up the environment variables
source tap-env.sh

# Check your env variables have been set
echo $(env | grep -E '(REGISTRY|NAMESPACE|AWS|INSTALL)')

# Set any required variables 
# export TAP_INSTALL_DIR= # e.g. $(pwd)
# export TANZU_NETWORK_TOKEN=<your token> # Obtained from your profile page on Tanzu Net

# Get the Tokens required
export TOKEN=$(curl -X POST https://network.pivotal.io/api/v2/authentication/access_tokens -d '{"refresh_token":"'${TANZU_NETWORK_TOKEN}'"}')
ACCESS_TOKEN=$(echo ${TOKEN} | jq -r .access_token)

# Login using the new token
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer ${ACCESS_TOKEN}" -X GET https://network.pivotal.io/api/v2/authentication

# Download Tanzu Cluster Essentials
rm -rf $TAP_INSTALL_DIR/tanzu-cluster-essentials
mkdir $TAP_INSTALL_DIR/tanzu-cluster-essentials
wget https://network.tanzu.vmware.com/api/v2/products/tanzu-cluster-essentials/releases/1011100/product_files/1105818/download --header="Authorization: Bearer ${ACCESS_TOKEN}" -O $TAP_INSTALL_DIR/tanzu-cluster-essentials/tanzu-cluster-essentials-linux-amd64-1.0.0.tgz
tar -xvf $TAP_INSTALL_DIR/tanzu-cluster-essentials/tanzu-cluster-essentials-linux-amd64-1.0.0.tgz -C $TAP_INSTALL_DIR/tanzu-cluster-essentials

# Install the kapp tool
sudo cp $TAP_INSTALL_DIR/tanzu-cluster-essentials/kapp /usr/local/bin/kapp

# Install Tanzu Cluster Essentials
echo "\nInstalling Tanzu Cluster Essentials into the cluster...\n"
cd $TAP_INSTALL_DIR/tanzu-cluster-essentials
export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
./install.sh

# View the cluster, you will see secretgen and kapp have been installed
kubectl get all --all-namespaces

# Check your installed plugins (some steps omitted for cli-setups)
tanzu plugin list
