#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 25 April 2025
# Purpose : Install mbutil to allow for creation of offline tilesets
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

APP=mbutil
VERSION=0.3.0
DOWNLOAD_FILE="${APP}-${VERSION}.tar.gz"
SRC_DIR="${ET_SRC_DIR}/${APP}-${VERSION}"
INSTALL_DIR="/opt/${APP}-${VERSION}"
INSTALL_BIN_DIR="${INSTALL_DIR}/bin"
LINK_PATH="/opt/${APP}"

et-log "Installing ${APP} ${VERSION}..."

if [[ ! -e "${ET_DIST_DIR}/${DOWNLOAD_FILE}" ]]; then

  URL="https://github.com/mapbox/mbutil/archive/refs/tags/v${VERSION}.tar.gz"

  et-log "Downloading ${APP}: ${URL}"
  curl -s -L -o ${DOWNLOAD_FILE} --fail ${URL}

  mv ${DOWNLOAD_FILE} ${ET_DIST_DIR}
fi

CWD_DIR=`pwd`

et-log "Unpacking ${APP} ${VERSION} source..."
tar -xzf "${ET_DIST_DIR}/${DOWNLOAD_FILE}"
mv "${APP}-${VERSION}" ${ET_SRC_DIR} && cd ${SRC_DIR}

et-log "Installing ${APP} ${VERSION} globally..."
python setup.py install

cd $CWD_DIR
