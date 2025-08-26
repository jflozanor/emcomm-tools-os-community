#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 26 April 2025
# Updated : 30 April 2025
# Purpose : Installs misc GIS tools from apt
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

et-log "Installing GIS tools..."

apt install \
  gpsbabel \
  gpsbabel-gui \
  sqlite3 \
  qgis \
  -y 
