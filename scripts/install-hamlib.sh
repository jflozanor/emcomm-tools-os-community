#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 25 November 2022
# Updated : 13 October 2025
# Purpose : Install hamlib for rig control (rigctld)
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh
. ../overlay/opt/emcomm-tools/bin/et-common

APP="hamlib"
# The latest verion of Hamlib 4.6.5 has a problem with initial client
# connections that can lead to rig control timeouts in applications like 
# JS8Call. Rolling back to version 4.5 which was stable.
#VERSION=4.6.5
VERSION=4.5
APP_AND_VERSION="${APP}-${VERSION}"
INSTALL_DIR="/opt/${APP_AND_VERSION}"
LINK_PATH="/opt/${APP}"
TARBALL=${APP_AND_VERSION}.tar.gz
URL=https://github.com/Hamlib/Hamlib/releases/download/${VERSION}/${TARBALL}

if [[ ! -e $ET_DIST_DIR/$TARBALL ]]; then
  et-log "Downloading hamlib: $URL "
  download_with_retries ${URL} ${TARBALL}

  [ ! -e ${ET_DIST_DIR} ] && mkdir -v ${ET_DIST_DIR}
  [ ! -e ${ET_SRC_DIR} ] && mkdir -v ${ET_SRC_DIR}

  mv ${TARBALL} ${ET_DIST_DIR}
fi

CWD_DIR=`pwd`

cd ${ET_SRC_DIR}
et-log "Unpacking ${ET_DIST_DIR}/${TARBALL}"
tar -xzf ${ET_DIST_DIR}/${TARBALL} && cd ${APP_AND_VERSION}

[ ! -e ${INSTALL_DIR} ] && mkdir -v ${INSTALL_DIR}

et-log "Building Hamlib ${VERSION}"
./configure --prefix=${INSTALL_DIR}
make && make check && make install

[ -e ${LINK_PATH} ] && rm ${LINK_PATH}
ln -v -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt ${APP} -t /usr/local

cd $CWD_DIR
