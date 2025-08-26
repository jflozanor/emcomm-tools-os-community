#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 25 April 2025
# Purpose : Installs Python 2
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

et-log "Installing Python 2..."

apt install \
  python2 \
  python-setuptools \
  -y 

# Set Python 2 as the default
update-alternatives --install /usr/bin/python python /usr/bin/python2 1
