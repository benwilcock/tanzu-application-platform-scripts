# Tanzu Application Platform (TAP) - Installation Environment Variables

# TAP Installation docker image registry - contains the TAP container images for installation and runtime use
export INSTALL_REGISTRY_USERNAME="" # "tanzu-net-username"
export INSTALL_REGISTRY_PASSWORD="" # "tanzu-net-password"

# Built application image container registry (holds supply-chain container images)
export DOCKER_SERVER="https://index.docker.io/v1/" # "or harbor.made-up-name.io"
export DOCKER_USERNAME="" # "your-dockerhub-username"
export DOCKER_PASSWORD="" # "your-dockerhub-password"

# Login to Tanzu net (https://network.tanzu.vmware.com/) and get this API token from your profile page.
export TANZU_NETWORK_TOKEN="" # Add your token here

