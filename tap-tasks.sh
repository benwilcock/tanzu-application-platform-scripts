#!/bin/bash

# To see your Minikube setup, use:
minikube profile list

# List the status of all TAP's sub components
tanzu package installed list -A 

# ************ Manual Step **************
# TAP GUI - Import the workload catalog from https://github.com/benwilcock/tanzu-java-web-app
# Harbor GUI Check for new container images

#########################
# Troubleshooting
#########################

tanzu package installed list -A # List the status of all TAP's sub components
tanzu package installed get tap -n ${TAP_NAMESPACE}
kubectl get pkgi buildservice -oyaml -n ${TAP_NAMESPACE}
kubectl get pkgi learningcenter-workshops -oyaml -n ${TAP_NAMESPACE}
kubectl get pkgi tap -oyaml -n ${TAP_NAMESPACE}
kubectl describe packageinstall buildservice -n tap-install

# Getting settings schemas
tanzu package installed list -A
tanzu package available get tap.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
tanzu package available get api-portal.tanzu.vmware.com/1.0.9 --values-schema -n tap-install

# Checking Live-view
kubectl get -n app-live-view service,deploy,pod
kubectl get -n alv-convention service,deploy,pod

# Checking Build System
kubectl get clusterbuilder.kpack.io -o yaml 
kubectl get image.kpack.io tanzu-java-web-app -o yaml
kubectl get build.kpack.io -o yaml

# Local loop (tilt?) needs Docker logged in to the demo repository
docker login demo.goharbor.io

# Dependency updaters need re-installing (container registry deleted issue)?
kubectl delete tanzunetdependencyupdater dependency-updater -n build-service

# Find all types of resources known to your cluster
kubectl api-resources

# Troubleshooting workload deployment
kubectl tree workload tanzu-java-web-app # Needs the 'Tree' plugin from Krew
kubectl get clusterbuilder.kpack.io -o yaml
kubectl get image.kpack.io <workload-name> -o yaml
kubectl get build.kpack.io -o yaml

# See what contour is proxying
kubectl get proxy -A

kubectl get secret -n build-service  kp-default-repository-secret
kubectl get secret -n default # Check the secrets in the default (dev) namespace
kubectl get secret registry-credentials -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d

# Restart stuff
kubectl rollout restart deployment server --namespace tap-gui

# Watch workload get built
tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp 

# Find out the registered trainig portals
kubectl get trainingportals

# Find out what URL's the Leaning center is hosting
kubectl get ingress -A

# Update TAP version 1.1.0 with new tap-values.yml
tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.1.1 --values-file tap-values.yml -n tap-install

# Remove and add TAP features (packageinstalls)
tanzu package installed delete buildservice --namespace tap-install -y
tanzu package installed create buildservice --package-name buildservice.tanzu.vmware.com --version 1.5.0 --namespace tap-install

# Checking Minikube disk size and usage (KVM2)
qemu-img info /home/ben/.minikube/machines/${TAP_PROFILE}/${TAP_PROFILE}.rawdisk