#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 24 April 2025
# Purpose : Install mbtileserver
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

APP=mbtileserver
VERSION=0.11.0
DOWNLOAD_FILE="${APP}_v${VERSION}_linux_amd64.zip"
BIN_FILE=QtTermTCP
INSTALL_DIR="/opt/${APP}-${VERSION}"
INSTALL_BIN_DIR="${INSTALL_DIR}/bin"
LINK_PATH="/opt/${APP}"

et-log "Installing ${APP} ${VERSION}..."

if [[ ! -e ${ET_DIST_DIR}/${DOWNLOAD_FILE} ]]; then

  URL="https://github.com/consbio/mbtileserver/releases/download/v${VERSION}/${DOWNLOAD_FILE}"

  et-log "Downloading ${APP}: ${URL}"
  curl -s -L -o ${DOWNLOAD_FILE} --fail ${URL}

  mv ${DOWNLOAD_FILE} ${ET_DIST_DIR}
fi

CWD_DIR=`pwd`

[[ ! -e ${INSTALL_BIN_DIR} ]] && mkdir -v -p ${INSTALL_BIN_DIR}
cd ${INSTALL_BIN_DIR}
unzip "${ET_DIST_DIR}/${DOWNLOAD_FILE}"
mv "mbtileserver_v${VERSION}_linux_amd64" ${APP} 
chmod 755 ${APP}

[[ -e ${LINK_PATH} ]] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt ${APP} -t /usr/local

cd $CWD_DIR
