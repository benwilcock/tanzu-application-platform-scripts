#!/bin/bash

source tap-env.sh

export ELB_HOST_NAME=$(kubectl get service envoy -n tanzu-system-ingress -o jsonpath='{.status.loadBalancer.ingress[].hostname}')
export ENVOY="$(host ${ELB_HOST_NAME} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)" # get the IP/URL for ingress
export HOSTS="benwilcock.io tap-gui.benwilcock.io"
export APPS_DOMAIN="apps.${ENVOY}.nip.io"

##################################
# Add some Workloads to TAP
##################################

 # Official Sample Workload:
tanzu apps workload create tanzu-java-web-app-sample \
--git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
--git-branch main \
--type web \
--label app.kubernetes.io/part-of=tanzu-java-web-app-sample \
--yes

# Spring Boot Admin Workload
tanzu apps workload create spring-boot-admin \
 --git-repo https://github.com/benwilcock/spring-boot-admin \
 --git-branch main \
 --type web \
 --label app.kubernetes.io/part-of=spring-boot-admin \
 --label tanzu.app.live.view=true \
 --label tanzu.app.live.view.application.name=spring-boot-admin \
 --yes \
 --namespace default 

# Tanzu Java Web App (With Spring Boot Admin Integration)
tanzu apps workload create tanzu-java-web-app \
 --git-repo https://github.com/benwilcock/tanzu-java-web-app \
 --git-branch main \
 --type web \
 --label app.kubernetes.io/part-of=tanzu-java-web-app \
 --label tanzu.app.live.view=true \
 --label tanzu.app.live.view.application.name=tanzu-java-web-app \
 --yes \
 --namespace default \
 --env "NAMESPACE=$TAP_DEV_NAMESPACE" \
 --env "DOMAIN=$APPS_DOMAIN" \
 --env "SPRING_PROFILES_ACTIVE=tap"

# Spring Config Server
tanzu apps workload create spring-config-server \
 --git-repo https://github.com/benwilcock/spring-config-server \
 --git-branch main \
 --type web \
 --label app.kubernetes.io/part-of=spring-config-server \
 --label tanzu.app.live.view=true \
 --label tanzu.app.live.view.application.name=spring-config-server \
 --yes \
 --namespace default \
 --env "NAMESPACE=default" \
 --env "DOMAIN=apps.benwilcock.io"

# Add Spring Boot Admin (SBA) Accelerator
tanzu accelerator create spring-boot-admin \
--git-repository https://github.com/benwilcock/spring-boot-admin \
--git-branch main \
--icon-url https://github.com/benwilcock/spring-boot-admin/raw/main/images/logo-spring-boot-admin.png 

kubectl apply -f sba-k8s-resource.yaml --namespace accelerator-system
tanzu accelerator update spring-boot-admin --reconcile

# Working with apps
tanzu apps workload list
tanzu apps workload get tanzu-java-web-app
tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp

# Checking deplyoment
http tanzu-java-web-app.${TAP_DEV_NAMESPACE}.apps.${ENVOY}.nip.io
kubectl describe runnable.carto.run/tanzu-java-web-app
