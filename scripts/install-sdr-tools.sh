#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 4 June 2025
# Purpose : Install SDR tools
set -e

et-log "Installing SDR tools..."
apt install \
  rtl-sdr \
  librtlsdr-dev \
  -y
