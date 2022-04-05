#!/bin/bash

##################################################################
# These functions and variables are used by the install scripts. #
# Make sure they're correct before you begin!                    #
##################################################################

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
DING='\007'

function yes_or_no {  
    while true; do
        read -p "$( echo -e ${YELLOW}$* ${NC}[y/n]: )" yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Moving on..." ; return 1 ;;
        esac
    done
}

function yes_or_quit {
    while true; do
        read -p "$( echo -e ${YELLOW}$* ${NC}[y/n]: )" yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Exiting" ; exit ;;
        esac
    done
}

function title {
    echo -e "${BLUE}$1${NC}"
}

function sub_title {
    echo -e "${WHITE}$1${NC}"
}

function alert {
    echo -e "${RED}$1${NC}"
}

function prompt {
    echo -e "${GREEN}$1${NC}"
}

function message {
    echo -e "${NC}$1${NC}"
}

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