# Set the environment variables
. .\tap-env.ps1

# *****vv******** From FIRST Administrator PowerShell *********vv*******
#------------------- SERVICES & NETWORKING -----------------------

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
minikube start --cpus=8 --memory=16g --kubernetes-version='1.22.6'

# To see your Minikube setup, use:
minikube profile list
# VM Driver: hyperv (VMware also works?)
# Runtime: docker

# Find the IP address for Minikube services (supplied by tunnel)
minikube ip

# Add a host entry for each app behind the tunnel (Windows 8 - 10)
Start-Process notepad -Verb runas "c:\Windows\System32\Drivers\etc\hosts"
# Add to the file...
# <your minikube ip> made-up-name.net tap-gui.made-up-name.net apps.made-up-name.net tanzu-java-web-app.default.apps.made-up-name.net

# Start the Minikube tunnel (needs admin, or there may be errors) 
minikube tunnel

# *****vv******** From Second Administrator PowerShell *********vv*******
# ---------------------- TANZU CLI -------------------------

# Download Tanzu CLI for Windows
# https://network.tanzu.vmware.com/products/tanzu-application-platform/#/releases/1043418/file_groups/6962
# Download tanzu-framework-windows-amd64.zip & extract the archive.
# Locate and copy the core/v0.11.1/tanzu-core-windows_amd64.exe into the new Program Files\tanzu folder.
# Copy "tanzu-framework-windows-amd64\cli\core\v0.11.1\tanzu-core-windows_amd64.exe" to "C:\Program Files\tanzu\tanzu-core-windows_amd64.exe"
# Rename "C:\Program Files\tanzu\tanzu-core-windows_amd64.exe" to "C:\Program Files\tanzu\tanzu.exe"

mkdir "C:\Program Files\tanzu"
cd "C:\Users\$env:USERNAME\Downloads\tanzu-framework-windows-amd64\"
cp "cli\core\v0.11.1\tanzu-core-windows_amd64.exe" "C:\Program Files\tanzu\tanzu.exe"

# Check the version...
tanzu version
# expect version: v0.11.1

# Install the Tanzu CLI Plugins
tanzu plugin install --local cli all

# Check the plugins
tanzu plugin list
# Ensure that you have the accelerator, apps, package, secret, and services plug-ins. 
# You need these plug-ins to install and interact with the Tanzu Application Platform.

# *******vv******** From A Regular PowerShell *********vv*********
# ----------------------- TCE INSTALL TO MINIKUBE --------------

kubectl create namespace tanzu-cluster-essentials
kubectl create namespace kapp-controller
kubectl create namespace secretgen-controller

# Wait for these to install correctly and start running before continuing
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.30.0/release.yml -n kapp-controller
kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.7.1/release.yml -n secretgen-controller
# ^^ Needs versions from a successful 1.0.0 or 1.0.1 TAP deployment


# ----------------------- TAP INSTALL TO MINIKUBE --------------

# Create the TAP INSTALL namespace
kubectl create ns $env:TAP_NAMESPACE

# Add the secret needed to use the TANZU Container Registry
tanzu secret registry add tap-registry `
  --username $env:INSTALL_REGISTRY_USERNAME --password $env:INSTALL_REGISTRY_PASSWORD `
  --server $env:INSTALL_REGISTRY_HOSTNAME `
  --export-to-all-namespaces --yes --namespace $env:TAP_NAMESPACE

tanzu package repository add tanzu-tap-repository `
  --url $env:INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$env:TAP_VERSION `
  --namespace $env:TAP_NAMESPACE

# Check for STATUS: Reconcile succeeded for the above package installation...
tanzu package repository get tanzu-tap-repository --namespace $env:TAP_NAMESPACE

# Check you can see a big list of packages...
tanzu package available list --namespace $env:TAP_NAMESPACE
# NAME                  DISPLAY-NAME                SHORT-DESCRIPTION                                                           LATEST-VERSION
# tap.tanzu.vmware.com  Tanzu Application Platform  Installs a set of TAP components to get you started based on your use case. 1.0.1
# etc. etc.

# Install TAP into Minikube - may take 30 mins or more - Assuming internet speeds of 40Mbps down and 10Mbps up (but more is better)
tanzu package install tap -p tap.tanzu.vmware.com -v $env:TAP_VERSION --values-file secret-tap-values.yml --namespace $env:TAP_NAMESPACE
# tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.1 -n tap-install -f secret-tap-values.yml

# Check everything has Reconcile succeeded. If not, wait some more and repeat.
tanzu package installed list -A

# ----------------- PREP DEV NAMESPACE -------------------------------

# Create a namespace for the developer to work in
kubectl create ns $env:TAP_DEV_NAMESPACE

# Add the secret for the BUILD Container Registry
tanzu secret registry add registry-credentials `
  --server $env:REGISTRY_SERVER `
  --username $env:REGISTRY_USERNAME `
  --password $env:REGISTRY_PASSWORD `
  --namespace $env:TAP_DEV_NAMESPACE

# Add the necessary RBAC Roles, Accounts, Bindings etc...
kubectl -n $env:TAP_DEV_NAMESPACE apply -f "serviceaccounts.yml"

# Check you can 'GET' the TAP user interface...
curl.exe http://tap-gui.made-up-name.net # Look out for: <title>Tanzu Application Platform</title> in the html code.

#------------------- RUN A JAVA WORKLOAD ON TAP ---------------------

# Official Sample Workload:
tanzu apps workload create tanzu-java-web-app `
--git-repo https://github.com/sample-accelerators/tanzu-java-web-app `
--git-branch main `
--type web `
--label app.kubernetes.io/part-of=tanzu-java-web-app `
--label tanzu.app.live.view=true `
--label tanzu.app.live.view.application.name=tanzu-java-web-app `
--namespace $env:TAP_DEV_NAMESPACE `
--yes

# Follow the progress of the buildpack as it compiles the code and builds a container image
tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp

# Find the status of your deployed apps...
tanzu apps workload list
# Your apps may be listed as 'Ready'

# After a while, eventually, you'll see a URL appear (be patient)
tanzu apps workload get tanzu-java-web-app
# NAME                 READY   URL
# tanzu-java-web-app   Ready   http://tanzu-java-web-app.default.apps.made-up-name.net

# Test your app.
curl.exe http://tanzu-java-web-app.default.apps.made-up-name.net
# Look out for: Greetings from Spring Boot + Tanzu!
# May take several seconds, as the app is spun up.

#------------------- Cleaning up ---------------------

# stop your minikube but keep the VM & data intact (https://minikube.sigs.k8s.io/docs/commands/stop/)
minikube stop

# Remove Tanzu CLI
rmdir  "C:\Program Files\tanzu" # Needs admin 

# Remove any unwanted container images from your container registry.
# ^^ Use your providers GUI or cli.