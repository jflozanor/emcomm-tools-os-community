#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 3 November 2024
# Updated : 12 November 2024
# Purpose : Install YAAC
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh
. ../overlay/opt/emcomm-tools/bin/et-common

VERSION=latest
ZIP_FILE=YAAC.zip
INSTALL_DIR=/opt/yaac-${VERSION}
LINK_PATH=/opt/yaac

et-log "Installing YAAC..."

URL=https://www.ka2ddo.org/ka2ddo/${ZIP_FILE}

et-log "Downloading YAAC: ${URL}"
download_with_retries ${URL} ${ZIP_FILE}

mv -v ${ZIP_FILE} ${ET_DIST_DIR}

CWD_DIR=$(pwd)

if [ ! -e ${INSTALL_DIR} ]; then
  mkdir -v ${INSTALL_DIR} && cd ${INSTALL_DIR}
  unzip ${ET_DIST_DIR}/${ZIP_FILE}
else
  et-log "${INSTALL_DIR} already exists."
fi

[ -e ${LINK_PATH} ] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

cd ${CWD_DIR}
