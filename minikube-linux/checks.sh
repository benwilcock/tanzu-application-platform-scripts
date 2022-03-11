#!/bin/bash

############## Pre Flight Checks... ##############################

# Make sure you add you credentials to  the file:
check_file "secret-${REPOSITORY_TYPE}-tap-env.sh"
check_file "secret-${REPOSITORY_TYPE}-tap-values.yml"