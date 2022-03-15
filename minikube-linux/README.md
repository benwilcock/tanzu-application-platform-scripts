# Installing The Tanzu Application Platform

These scripts (written primarily for the Linux `bash` shell) help you to install [Tanzu Application Platform](https://tanzu.vmware.com/application-platform) (TAP) onto a Kubernetes cluster. To understand more about this process you can read the [TAP installation documentation](https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-overview.html). It's worth noting that the system requirements for running Tanzu Application platform locally like this are quite high:

* **Hardware:** A PC or Laptop with a modern Intel i7 or AMD Ryzen 7 processor (or better) with at least 8 CPU threads, 12GB of RAM, and 40 GB of disk space. 
* **Operating System:** Ubuntu 20.04 LTS with super user access. 
* **Accounts:** You’ll need the username and password for your Docker Hub account and the username and password for your account on the Tanzu Network (registration is free). 
* **Time:** About 1 hour (but this can vary depending on your bandwidth, processor, RAM, etc.). 
* **Connectivity:** A stable broadband connection capable of at least 30Mbs download and 10Mbs upload. 

These scripts assume that you want to work locally with Minikube, but can be adapted to other types of Kubernetes (like EKS for example) quite easily. To use these scripts as they are, do the following:

## Ensure You Have The Required Rools

* Install [`minikube`](https://minikube.sigs.k8s.io/docs/start/) (allows localized kubernetes cluster to be run on your PC)
* Install [`kubectl`](https://kubernetes.io/docs/tasks/tools/) (allows communication and control of resources inside Minikube)
* Install [`xclip`](https://github.com/astrand/xclip) (allows output from terminal commands to be copied to the clipboard)
* Install [`curl`](https://curl.se/) (allows for workloads to be tested with simple HTTP request-response)

Check that the tools mentioned above are all working for you before you continue.

## Obtain The Required Files And Binaries

Some of the scripts rely on certain files being available, some of which need downloading before you begin your installation.

1. Clone this git repo locally and `cd` to the [`minikube-linux`](https://github.com/benwilcock/tanzu-application-platform-scripts/tree/main/minikube-linux) folder.
1. Download the [Tanzu CLI from the Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/) to this folder (requires an account, but these are free).
1. Download the [Tanzu Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/) to this folder (macOS and Linux only. For Windows you can skip this item).

## Customize Your TAP Installation Settings

1. Customize the installation settings in the file [`settings.sh`](settings.sh) including your `$REGISTRY_TYPE` etc.

## Create Your TAP Configuration Files

Next, you need to open a text editor or an IDE and create some files needed to configure the TAP system.

1. Create the file `secret-$(REGISTRY-TYPE}-tap-env.sh` (start with the [template provided](template-tap-env.sh)).
1. Create the file `secret-$(REGISTRY-TYPE}-tap-values.yml` (start with the [template provided](template-tap-values.yml)).

## Install the Tanzu CLI Tool

Open a terminal and run the `stage-1` script (installs the Tanzu CLI). Follow the prompts. 

## Start Minikube

Run the `stage-2` script (starts minikube). Follow the prompts. Edit your `/etc/hosts` file as directed. Let the script start the `minikube tunnel` and leave it running in this terminal window. 

> If you're using a different type of Kubernetes, you'll need to adapt this part to suit your needs.

## Install The Tanzu Application Platform To Minikube

1. Open a second terminal window.
1. Run the `stage-3` to install Tanzu Cluster Essentials for VMware Tanzu.
1. Run the `stage-4` script to install Tanzu Application Platform.
1. Run the `stage-5` script to create a developer workspace and add the required repository and secrets.
1. Run the `stage-6` script to deploy a test application workload.
1. Run the `stage-7` script to test the application workload with `curl`.

You now have a fully working Tanzu Application Platform installation on Minikube. If you're not using Minikube, you may need to make some adjustments to these steps to suit your needs.

### Hints

> You can try and run the `stage-3` script onwards against any kubernetes (they just might work).

> On Fedora 35, I found that the winning combination was using TAP version 1.0.2 onwards with the `kvm2` VM driver for Minikube. Older TAP versions, or the `docker` VM driver for Minikube did not work when I tested them. 