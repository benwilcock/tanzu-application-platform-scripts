# Install Tanzu Application Platform

To use these scripts, do the following:

## Make sure you have the required tools

1. Install `minikube` (allows localized kubernetes cluster to be run on your PC)
1. Install `kubectl` (allows communication and control of resources inside Minikube)
1. Install `xclip` (allows output from terminal commands to be copied to the clipboard)

Check these tools are working before you continue.

## Download some stuff

1. Clone this git repo locally and go to the `minikube-linux` folder.
1. Download to this folder the Tanzu CLI from the Tanzu Network (requires an account, but these are free).
1. Download to this folder the Tanzu Cluster Essentials for VMware Tanzu from the Tanzu Network (requires an account, but these are free).

## Customize your installation settings

1. Customize the installation settings in `settings.sh` including your `$REGISTRY_TYPE` and location etc.

## Create some files

1. Create your file `secret-$(REGISTRY-TYPE}-tap-env.sh` using the template provided.
1. Create your file `secret-$(REGISTRY-TYPE}-tap-values.yml` using the template provided.


## Install the Tanzu Tools (scripted)

Open a terminal and run the `stage-1` script (installs the Tanzu CLI). 

## Start Minikube (scripted)

Run the `stage-2` script (start minikube) scripts. Follow the prompts. Leave this terminal window open with the `minikube tunnel` running.

## Install TAP to your Kubernetes cluster (scripted)

Open a second terminal and run the `stage-3` (install TCE) scripts onwards.

By `stage-7` you should have a fully working TAP platform ready to code against.

### Hints

> You don't have to use Minikube. You can try and run the `stage-3` script onwards against any kubernetes (they just might work).

> On Fedora 35, I found that the winning combination was using TAP version 1.1 with the `kvm2` driver with Minikube. Older TAP versions, or the `docker` VM driver for Minikube did not work when I tested them. 