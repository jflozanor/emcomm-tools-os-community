#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 2 October 2025
# Purpose : Builds and installs et-portaudio
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

APP="et-portaudio"
VERSION="1.0.0"
APP_AND_VERSION="${APP}-${VERSION}"
INSTALL_DIR="/opt/${APP_AND_VERSION}"
LINK_PATH="/opt/${APP}"

et-log "Installing ${APP} ${VERSION}"

CWD_DIR=`pwd`

cd ../src/et-portaudio

# Compile
make install

[[ -e ${LINK_PATH} ]] && rm ${LINK_PATH}
ln -v -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt ${APP} -t /usr/local

cd ${CWD}
