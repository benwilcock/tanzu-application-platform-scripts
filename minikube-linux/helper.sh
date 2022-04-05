#!/bin/bash

# Pull in the various variables and functions required by the scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/functions.sh"
. "$DIR/settings.sh"
. "$DIR/checks.sh"
