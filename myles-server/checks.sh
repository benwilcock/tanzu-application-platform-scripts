#!/bin/bash

############## Pre Flight Checks... ##############################

# Check the settings
[ -z "$VSPHERE_SERVER" ] && { echo "VSPHERE_SERVER env var must not be empty"; exit 1; }
[ -z "$KUBECTL_VSPHERE_PASSWORD" ] && { echo "KUBECTL_VSPHERE_PASSWORD env var must not be empty"; exit 1; }
[ -z "$VSPHERE_USER" ] && { echo "VSPHERE_USER env var must not be empty"; exit 1; }
[ -z "$TAP_DEV_NAMESPACE" ] && { echo "TAP_DEV_NAMESPACE env var must not be empty"; exit 1; }


