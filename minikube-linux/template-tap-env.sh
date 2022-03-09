# Tanzu Application Platform (TAP) - Installation Environment Variables

# TAP Installation docker image registry - contains the TAP container images for installation and runtime use
$Env:INSTALL_REGISTRY_HOSTNAME = "registry.tanzu.vmware.com"
$Env:INSTALL_REGISTRY_USERNAME = "" # "tanzu-net-username"
$Env:INSTALL_REGISTRY_PASSWORD = "" # "tanzu-net-password"

# Built application image container registry (holds supply-chain container images)
$Env:DOCKER_SERVER = "https://index.docker.io/v1/" # "or harbor.made-up-name.io"
$Env:DOCKER_USERNAME = "" # "your-dockerhub-username"
$Env:DOCKER_PASSWORD = "" # "your-dockerhub-password"

