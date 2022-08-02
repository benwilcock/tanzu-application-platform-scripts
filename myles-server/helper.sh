#!/bin/bash

# Checking if a file exists
function check_file {

    DIR="${BASH_SOURCE%/*}"
    if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
    FILE="$DIR/$1"

    if [ -f $FILE ]; then
        return 0;
    else 
        echo -e "${WHITE}Failed the file check. The file ${RED}${FILE}${WHITE} is missing!${NC}"
        exit
    fi
}

# Pull in the various variables and functions required by the scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
check_file "settings.sh"
. "$DIR/settings.sh"
check_file "functions.sh"
. "$DIR/functions.sh"
check_file "secrets.sh"
. "$DIR/secrets.sh"
check_file "checks.sh"
. "$DIR/checks.sh"
