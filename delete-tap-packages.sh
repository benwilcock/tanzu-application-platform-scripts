#!/usr/bin/bash

tanzu package installed delete accelerator --namespace tap-install -y
tanzu package installed delete appliveview --namespace tap-install -y
tanzu package installed delete appliveview-conventions --namespace tap-install -y
tanzu package installed delete buildservice --namespace tap-install -y
tanzu package installed delete cartographer --namespace tap-install -y
tanzu package installed delete cert-manager --namespace tap-install -y
tanzu package installed delete cnrs --namespace tap-install -y
tanzu package installed delete contour --namespace tap-install -y
tanzu package installed delete conventions-controller --namespace tap-install -y
tanzu package installed delete developer-conventions --namespace tap-install -y
tanzu package installed delete fluxcd-source-controller --namespace tap-install -y
tanzu package installed delete ootb-delivery-basic --namespace tap-install -y
tanzu package installed delete ootb-supply-chain-basic --namespace tap-install -y
tanzu package installed delete ootb-templates --namespace tap-install -y
tanzu package installed delete service-bindings --namespace tap-install -y
tanzu package installed delete services-toolkit --namespace tap-install -y
tanzu package installed delete source-controller --namespace tap-install -y
tanzu package installed delete spring-boot-conventions --namespace tap-install -y
tanzu package installed delete tap --namespace tap-install -y
tanzu package installed delete tap-gui --namespace tap-install -y
tanzu package installed delete tap-telemetry --namespace tap-install -y
tanzu package installed delete tekton-pipelines --namespace tap-install -y
tanzu package installed delete api-portal --namespace tap-install -y                                                                                                    
tanzu package installed delete grype --namespace tap-install -y                                                  
tanzu package installed delete image-policy-webhook --namespace tap-install -y                                                  
tanzu package installed delete learningcenter --namespace tap-install -y                                                    
tanzu package installed delete learningcenter-workshops --namespace tap-install -y                                                 
tanzu package installed delete metadata-store --namespace tap-install -y                                                                                                    
tanzu package installed delete scanning --namespace tap-install -y                                                  

# Pause Minikube
#minikube pause

# Stop Minikube
# minikube stop

# Delete the cluster
# Warning - this will also delete all the container images so if you're starting over, they'll be downloaded afresh.
# minikube delete