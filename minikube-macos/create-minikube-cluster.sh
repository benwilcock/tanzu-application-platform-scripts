## Stage 1: Running minikube (MacOS commands)

minikube start --cpus=6 --memory=16g --kubernetes-version='1.22.6'      # I only have 6 cores :(

minikube ip

export MINIKUBE_IP=192.168.49.2
export LOCAL_DOMAIN=vetter.wtf


sudo echo "$MINIKUBE_IP tap-gui.$LOCAL_DOMAIN tanzu-java-web-app.default.apps.$LOCAL_DOMAIN" | sudo tee -a /etc/hosts

minikube tunnel


## Stage 2: Installing the Tanzu CLI Tool v0.11.1.

mkdir ~/tanzu

pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.0.1' --product-file-id=1156161 # if we don't want to use the pivnet cli, we can just use the paragraph in the doc already for downloading it directly

tar -xvf tanzu-framework-darwin-amd64.tar -C ~/tanzu

cd ~/tanzu

sudo install cli/core/v0.11.1/tanzu-core-darwin_amd64 /usr/local/bin/tanzu

tanzu version
Example output
version: v0.11.1
buildDate: 2022-02-14
sha: 4d578570

export TANZU_CLI_NO_INIT=true

tanzu plugin install --local cli all

tanzu plugin list
Example output
  NAME                DESCRIPTION                                                        SCOPE       DISCOVERY  VERSION  STATUS
  login               Login to the platform                                              Standalone  default    v0.11.1  not installed
  management-cluster  Kubernetes management-cluster operations                           Standalone  default    v0.11.1  not installed
  package             Tanzu package management                                           Standalone  default    v0.11.1  installed
  pinniped-auth       Pinniped authentication operations (usually not directly invoked)  Standalone  default    v0.11.1  not installed
  secret              Tanzu secret management                                            Standalone  default    v0.11.1  installed
  services            Discover Service Types and manage Service Instances (ALPHA)        Standalone             v0.1.1   installed
  accelerator         Manage accelerators in a Kubernetes cluster                        Standalone             v1.0.1   installed
  apps                Applications on Kubernetes                                         Standalone             v0.4.1   installed

## Stage 3: Installing Tanzu Cluster Essentials onto Minikube

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=username@vmware.com
export INSTALL_REGISTRY_PASSWORD=password_one

pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.0.0' --product-file-id=1105820    # or download from here: https://network.pivotal.io/products/tanzu-cluster-essentials/

mkdir ~/tanzu-cluster-essentials

tar -xvf tanzu-cluster-essentials-darwin-amd64-1.0.0.tgz -C ~/tanzu-cluster-essentials

cd ~/tanzu-cluster-essentials

./install.sh

sudo cp ~/tanzu-cluster-essentials/kapp /usr/local/bin/kapp

kubectl create ns tap-install

kubectl get pods --all-namespaces

## Stage 4: Installing Tanzu Application Platform onto Minikube

export TAP_VERSION="1.0.2-build.8"
export TAP_NAMESPACE="tap-install"
export INSTALL_REGISTRY_HOSTNAME="registry.tanzu.vmware.com"
export INSTALL_REGISTRY_USERNAME="username@vmware.com"
export INSTALL_REGISTRY_PASSWORD="password"
export DOCKER_SERVER="https://index.docker.io/v1/"
export DOCKER_USERNAME="username"
export DOCKER_PASSWORD="password"

tanzu secret registry add tap-registry \
  --username $INSTALL_REGISTRY_USERNAME --password $INSTALL_REGISTRY_PASSWORD \
  --server $INSTALL_REGISTRY_HOSTNAME \
  --export-to-all-namespaces --yes --namespace $TAP_NAMESPACE

tanzu package repository get tanzu-tap-repository --namespace $TAP_NAMESPACE

tanzu package available list --namespace $TAP_NAMESPACE


cat << EOF > tap-values.yaml
profile: light
ceip_policy_disclosed: true

buildservice:
    kp_default_repository: "$DOCKER_USERNAME/build-service"
    kp_default_repository_username: "$DOCKER_USERNAME"
    kp_default_repository_password: "$DOCKER_PASSWORD"
    tanzunet_username: "$INSTALL_REGISTRY_USERNAME"
    tanzunet_password: "$INSTALL_REGISTRY_PASSWORD"
    enable_automatic_dependency_updates: true

supply_chain: basic

ootb_supply_chain_basic:
    registry:
        server: "index.docker.io"
        repository: "$DOCKER_USERNAME"
    gitops:
        ssh_secret: ""

tap_gui:
    service_type: ClusterIP
    ingressEnabled: "true"
    ingressDomain: "$LOCAL_DOMAIN"
    app_config:
        app:
            baseUrl: http://tap-gui.$LOCAL_DOMAIN
        catalog:
            locations:
                - type: url
                  target: https://github.com/$GITHUB_USERNAME/blank-catalog/blob/main/catalog-info.yaml
        backend:
            baseUrl: http://tap-gui.$LOCAL_DOMAIN
            cors:
                origin: http://tap-gui.$LOCAL_DOMAIN

cnrs:
    domain_name: apps.$LOCAL_DOMAIN

contour:
    envoy:
        service:
            type: LoadBalancer
EOF


tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values-test.yaml --namespace $TAP_NAMESPACE

tanzu package installed list -A

