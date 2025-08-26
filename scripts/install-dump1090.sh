#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 4 June 2025
# Updated : 6 July 2025
# Purpose : Install dump1090 (ADB-S aircraft tracking)
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

APP=dump1090
VERSION=master
DOWNLOAD_FILE=dump1090-master.zip
BIN_FILE=dump1090
INSTALL_DIR="/opt/${APP}-${VERSION}"
INSTALL_BIN_DIR="${INSTALL_DIR}/bin"
LINK_PATH="/opt/${APP}"
DUMP1090_CONF_DIR="/etc/skel/.local/share/emcomm-tools/dump1090"

if [[ ! -e ${ET_DIST_DIR}/${DOWNLOAD_FILE} ]]; then

  URL="https://github.com/thetechprepper/dump1090/archive/refs/heads/master.zip"

  et-log "Downloading ${APP}: ${URL}"
  curl -s -L -o ${DOWNLOAD_FILE} --fail ${URL}

  mv -v ${DOWNLOAD_FILE} ${ET_DIST_DIR}
fi

CWD_DIR=`pwd`

# Only build once
if [[ ! -e "${ET_SRC_DIR}/${APP}/${BIN_FILE}" ]]; then
  cd ${ET_SRC_DIR}
  unzip -o ${ET_DIST_DIR}/${DOWNLOAD_FILE}

  cd dump1090-master 

  et-log "Building ${APP}.."
  make
fi

[[ ! -e ${INSTALL_BIN_DIR} ]] && mkdir -v -p ${INSTALL_BIN_DIR}
cp -v "${ET_SRC_DIR}/${APP}-master/${BIN_FILE}" ${INSTALL_BIN_DIR}

# Install HTML map
[[ ! -e ${DUMP1090_CONF_DIR} ]] && mkdir -v -p ${DUMP1090_CONF_DIR}
cp -v "${ET_SRC_DIR}/${APP}-master/gmap.html" ${DUMP1090_CONF_DIR}

[[ -e ${LINK_PATH} ]] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt ${APP} -t /usr/local

cd $CWD_DIR

et-log "Updating launcher icon to support PNP..."
cp -v ../overlay/usr/share/applications/et-aircraft.desktop /usr/share/applications/

