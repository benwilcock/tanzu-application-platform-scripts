
# Set a bunch of environment variables we will use during the installation process
. .\tap-env.ps1

# Check your variables have been setup
dir env: 

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
minikube start --cpus=8 --memory=16g --kubernetes-version='1.22.6'