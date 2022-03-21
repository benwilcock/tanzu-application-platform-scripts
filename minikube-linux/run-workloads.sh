#!/bin/bash

# Setup the environment
source ./helper.sh

export TAP_DEV_NAMESPACE='default'
export APPS_DOMAIN='apps.example.com'
export SPRING_PROFILES_ACTIVE='tap'


##################################
# Add some Workloads to TAP
##################################

# Spring Boot Admin
tanzu apps workload create spring-boot-admin \
 --git-repo https://github.com/benwilcock/spring-boot-admin \
 --git-branch main \
 --type web \
 --label app.kubernetes.io/part-of=spring-boot-admin \
 --label tanzu.app.live.view=true \
 --label tanzu.app.live.view.application.name=spring-boot-admin \
 --namespace $TAP_DEV_NAMESPACE

# Watch the workload as it deploys
yes_or_no "Would you like to watch the workload become ready?" && \
watch --color "tanzu apps workload get spring-boot-admin; echo -e '${GREEN}Wait for the Workload to become ${WHITE}READY${GREEN} and get a ${WHITE}URL${GREEN}. Then press Ctrl-C to continue.${NC}'"


 # Spring Config Server
tanzu apps workload create spring-config-server \
 --git-repo https://github.com/benwilcock/spring-config-server \
 --git-branch main \
 --type web \
 --label app.kubernetes.io/part-of=spring-config-server \
 --label tanzu.app.live.view=true \
 --label tanzu.app.live.view.application.name=spring-config-server \
 --namespace $TAP_DEV_NAMESPACE \
 --env "NAMESPACE=$TAP_DEV_NAMESPACE" \
 --env "DOMAIN=$APPS_DOMAIN"

# Watch the workload as it deploys
yes_or_no "Would you like to watch the workload become ready?" && \
watch --color "tanzu apps workload get spring-config-server; echo -e '${GREEN}Wait for the Workload to become ${WHITE}READY${GREEN} and get a ${WHITE}URL${GREEN}. Then press Ctrl-C to continue.${NC}'"


# Tanzu Java Web App (With Spring Boot Admin Integration)
tanzu apps workload create tanzu-java-web-app \
 --git-repo https://github.com/benwilcock/tanzu-java-web-app \
 --git-branch main \
 --type web \
 --label app.kubernetes.io/part-of=tanzu-java-web-app \
 --label tanzu.app.live.view=true \
 --label tanzu.app.live.view.application.name=tanzu-java-web-app \
 --namespace $TAP_DEV_NAMESPACE \
 --env "NAMESPACE=$TAP_DEV_NAMESPACE" \
 --env "DOMAIN=$APPS_DOMAIN" \
 --env "SPRING_PROFILES_ACTIVE=$SPRING_PROFILES_ACTIVE"

# Watch the workload as it deploys
yes_or_no "Would you like to watch the workload become ready?" && \
watch --color "tanzu apps workload get tanzu-java-web-app; echo -e '${GREEN}Wait for the Workload to become ${WHITE}READY${GREEN} and get a ${WHITE}URL${GREEN}. Then press Ctrl-C to continue.${NC}'"


# # Add Spring Boot Admin (SBA) Accelerator
yes_or_quit "Deploy the Spring Boot Admin Accelerator?"

tanzu accelerator create spring-boot-admin \
--git-repository https://github.com/benwilcock/spring-boot-admin \
--git-branch main \
--icon-url https://github.com/benwilcock/spring-boot-admin/raw/main/images/logo-spring-boot-admin.png 

kubectl apply -f secret-sba-k8s-resource.yaml --namespace accelerator-system

tanzu accelerator update spring-boot-admin --reconcile

# # Working with apps
# tanzu apps workload list
# tanzu apps workload get tanzu-java-web-app
# tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp

# # Checking deplyoment
# http tanzu-java-web-app.${TAP_DEV_NAMESPACE}.apps.${ENVOY}.nip.io
# kubectl describe runnable.carto.run/tanzu-java-web-app
