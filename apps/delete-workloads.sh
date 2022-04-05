#!/bin/bash

source ../minikube-linux/helper.sh

##################################
# Add some Workloads to TAP
##################################

# Spring Boot Admin
yes_or_no "Delete Spring Boot Admin?" \
    && tanzu apps workload delete spring-boot-admin \
        --yes 

# Spring Config Server
yes_or_no "Delete Spring Config Server?" \
    && tanzu apps workload delete spring-config-server \
        --yes 

# Tanzu Java Web App (With Spring Boot Admin Integration)
yes_or_no "Delete Tanzu Java Web App?" \
    && tanzu apps workload delete tanzu-java-web-app \
        --yes

# Working with apps
yes_or_no "Watch the Workloads be removed?" \
    && watch --color "tanzu apps workload list; echo -e '${GREEN}When the workloads have gone, press Ctrl-C to exit.${NC}'"


# Adding the host entries to the hosts file (needs sudo)
export ENVOY="$(minikube ip)"
export HOSTS="spring-boot-admin.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN} spring-config-server.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN} tanzu-java-web-app.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN}"
message "You must remove ${GREEN}'${ENVOY} ${HOSTS}'${NC} from your '/etc/hosts' file."
message "This will prevent http requests being routed to your applications."
yes_or_no "Opening /etc/hosts in Nano (needs sudo) for you. Use Ctrl+K to delete the line. Ready?" \
  && sudo nano /etc/hosts
