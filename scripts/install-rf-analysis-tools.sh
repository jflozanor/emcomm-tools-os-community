#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 22 May 2024
# Updated : 4 June 2025
# Purpose : Install RF prediction and analysis tools
set -e

et-log "Installing RF prediction and analysis tools..."
apt install \
  splat \
  -y
