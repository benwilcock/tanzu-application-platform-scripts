################################################################
# Tanzu Cluster Essentials (TCE) is required inside            #
# Kubernetes for the Tanzu CLI to pass instructions to.        #
# If your Kubernetes already has TCE you can skip this step.   #
################################################################
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color
echo -e "${BLUE}Stage 3 - Install Cluster Essentials for VMware Tanzu${NC}" 
echo -e "${GREEN}This script installs components required by TAP. If you use TKG v1.5.1 or later you can skip this step.${NC}"
sleep 5

# First, create the required Kubernetes namespaces. 
kubectl create namespace tanzu-cluster-essentials 
kubectl create namespace kapp-controller 
kubectl create namespace secretgen-controller

# Next, apply the YAML configurations for the required apps: 
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.30.0/release.yml -n kapp-controller 
kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.7.1/release.yml -n secretgen-controller 

sleep 5
watch --color "kubectl get pods --all-namespaces; echo -e '${GREEN}When all pods have a STATUS of Running, press Ctrl-C to exit and run the stage-4 script.${NC}'"
