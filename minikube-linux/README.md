# Install Tanzu Application Platform

To use these scripts, do the following:

## Get Set Up

1. Clone this repo locally and got to the `minikube-linux` folder.
1. Download to this folder the Tanzu CLI from the Tanzu Network (requires an account, but these are free).
1. Download to this folder the Tanzu Cluster Essentials for VMware Tanzu from the Tanzu Network (requires an account, but these are free).
1. Set your installation settings in `settings.sh` including your `$REGISTRY_TYPE` and location etc.
1. Create your file `secret-$(REGISTRY-TYPE}-tap-env.sh` using the template provided.
1. Create your file `secret-$(REGISTRY-TYPE}-tap-values.yml` using the template provided.


## Establish the pre-requisites

Then, open a terminal and run the `stage-1` (install the Tanzu CLI) and `stage-2` (start minikube) scripts. Follow the prompts. Leave this terminal with the `minikube tunnel` running.

## Install TAP to your Kubernetes cluster

Then, open another terminal and run the `stage-3` (install TCE) scripts onwards.

By `stage-7` you should have a fully working TAP platform ready to code against.

### Notes

You don't have to use Minikube. You can run stage-2 onwards against any kubernetes, they just might not work.

### Hints

On Fedora 35, I found that the winning combination was using TAP version 1.1 with the `kvm2` driver with Minikube. Older TAP versions, or the `docker` VM driver for Minikube did not work when I tested them. 