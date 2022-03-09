################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Choose where Built container images will go...
export REPOSITORY_TYPE="dockerhub" # One of "dockerhub" "harbor" "local"

# Specify the version of TAP to install
export TAP_VERSION="1.0.2" # "1.1.0-build.5" # "1.0.1" "1.0.2-build.8"


echo -e "${BLUE}Stage 4 - Install the Tanzu Application Platform (TAP)${NC}" 
echo -e "${GREEN}This script installs TAP ${WHITE}${TAP_VERSION}${GREEN} onto Kubernetes with your supply-chain container images being stored in ${WHITE}${REPOSITORY_TYPE}${GREEN}.${NC}"
sleep 5


# Namespace for the TAP installation components
export TAP_NAMESPACE="tap-install"

# Source the environment variables
source ./secret-$REPOSITORY_TYPE-tap-env.sh

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

sleep 10

# Check you're ready to go and that K8s has all the 'TAP Cluster Essentials' like `kapp-controller` and TAP repositories installed... 
# tanzu package repository get tanzu-tap-repository --namespace $TAP_NAMESPACE # Has the reconcile succeeded?
# tanzu package available list tap.tanzu.vmware.com --namespace $TAP_NAMESPACE # Is tap.tanzu.vmware.com in the list?
# tanzu package available list --namespace $TAP_NAMESPACE # Do you see a big list of all TAP packages and versions?

if [ "$REPOSITORY_TYPE" = "dockerhub" ]
  then
    echo -e "${RED} DockerHub FREE accounts have user pull limits.${NC} You may struggle to install TAP."
  fi

# Install the TAP packages to Kubernetes
echo -e "${BLUE}This may take 30 mins or more and use lots of compute and network resources. Go grap a coffee!${NC}"
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION \
  --values-file secret-$REPOSITORY_TYPE-tap-values.yml \
  --namespace $TAP_NAMESPACE

# Watch the progress of the installation
watch --color "tanzu package installed list -A; echo -e '${GREEN}When ALL packages have a STATUS of 'Reconcile Succeeded', press Ctrl-C to exit and run the stage-5 script.${NC}'"
