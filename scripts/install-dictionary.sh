#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 22 July 2025
# Purpose : Install a small offline English dictionary

et-log "Installing offline dictionary..."

apt install \
  dict \
  dictd \
  dict-gcide \
  -y
