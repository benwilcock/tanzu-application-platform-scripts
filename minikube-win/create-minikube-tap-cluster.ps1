# Set the environment variables
. .\tap-env.ps1

# ---------------------- TANZU CLI -------------------------

# Download Tanzu CLI for Windows
# https://network.tanzu.vmware.com/products/tanzu-application-platform/#/releases/1043418/file_groups/6962
# Download tanzu-framework-windows-amd64.zip & extract the archive.
# Locate and copy the core/v0.11.1/tanzu-core-windows_amd64.exe into the new Program Files\tanzu folder.
# Copy "Downloads\tanzu-framework-windows-amd64\cli\core\v0.11.1\tanzu-core-windows_amd64.exe" to "C:\Program Files\tanzu\tanzu-core-windows_amd64.exe"
# Rename "C:\Program Files\tanzu\tanzu-core-windows_amd64.exe" to "C:\Program Files\tanzu\tanzu.exe"
# cp C:\Users\$env:USERNAME\Downloads\tanzu-framework-windows-amd64\cli\core\v0.11.1\tanzu-core-windows_amd64.exe C:\Program Files\tanzu\tanzu.exe

# Check the version...
tanzu version
# expect version: v0.11.1

# Install the Tanzu CLI Plugins
# tanzu plugin install --local cli all

# Check the plugins
tanzu plugin list
# Ensure that you have the accelerator, apps, package, secret, and services plug-ins. 
# You need these plug-ins to install and interact with the Tanzu Application Platform.

# ----------------------- TAP INSTALL ONTO MINIKUBE --------------

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
minikube start --cpus=8 --memory=16g --kubernetes-version='1.22.6'

kubectl create namespace tanzu-cluster-essentials
kubectl create namespace kapp-controller
kubectl create namespace secretgen-controller
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.30.0/release.yml -n kapp-controller
kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.7.1/release.yml -n secretgen-controller
# ^^ Needs versions from a successful 1.0.0 or 1.0.1 TAP deployment

kubectl create ns $env:TAP_NAMESPACE

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
#tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.1 -n tap-install -f secret-tap-values.yml

# ----------------- DEV AREA PREP -------------------------------

# Create a namespace for the developer to work in
kubectl create ns $env:TAP_DEV_NAMESPACE

# Make it possible for the build-service to push and pull images on behalf of the developer
tanzu secret registry add registry-credentials `
  --server $env:REGISTRY_SERVER `
  --username $env:REGISTRY_USERNAME `
  --password $env:REGISTRY_PASSWORD `
  --namespace $env:TAP_DEV_NAMESPACE

# Add the necessary Roles, Accounts, Bindings etc...
kubectl -n $env:TAP_DEV_NAMESPACE apply -f "serviceaccounts.yml"

#------------------- SERVICES & NETWORKING -----------------------

# Start the Minikube service tunnel (in a separate Powershell Window) 
minikube tunnel

# Find the IP address for Minikube services (supplied by tunnel)
minikube ip

# Add in a special host entry for each app behind the tunnel (Windows 8 - 10)
Start-Process notepad -Verb runas "c:\Windows\System32\Drivers\etc\hosts"
# Add to the file...
# <your minikube ip> made-up-name.net tap-gui.made-up-name.net apps.made-up-name.net tanzu-java-web-app.default.apps.made-up-name.net
# 192.168.92.128 made-up-name.net tap-gui.made-up-name.net apps.made-up-name.net tanzu-java-web-app.default.apps.made-up-name.net

# Check you can 'GET' the TAP user interface
curl.exe http://tap-gui.made-up-name.net # Look out for: <title>Tanzu Application Platform</title>

# Check everything has Reconcile succeeded. If not, wait and repeat.
tanzu package installed list -A

#------------------- RUNNING WORKLOADS ON TAP ---------------------

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

# Follow the progress of the build (until it stops piping or you get bored)
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

# stop your minikube but keep the VM & data intact (https://minikube.sigs.k8s.io/docs/commands/stop/)
minikube stop