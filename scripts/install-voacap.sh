#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 5 June 2023
# Updated : 16 August 2025
# Purpose : Install Dire Wolf
#
# References:
# 1. https://github.com/jawatson/voacapl
# 2. https://github.com/jawatson/voacapl/wiki
# 3. http://www.greg-hand.com/hfwin32.html
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

APP=voacapl
VERSION=0.7.6
REPO=https://github.com/thetechprepper/voacapl
REPO_SRC_DIR="/opt/src/${APP}"
INSTALL_DIR="/opt/${APP}-${VERSION}"
LINK_PATH="/opt/${APP}"

et-log "Installing voacapl build dependencies..."
apt install gfortran -y

[[ ! -e ${ET_SRC_DIR} ]] && mkdir ${ET_SRC_DIR}

CWD_DIR=`pwd`

if [[ ! -e ${REPO_SRC_DIR} ]]; then
  cd ${ET_SRC_DIR} && git clone ${REPO}
fi

cd ${REPO_SRC_DIR}
autoreconf -f -i
./configure --prefix=${INSTALL_DIR}
make && make install

# patch prefix location
sed -i 's|__PREFIX__|/opt/voacapl-0.7.6|' makeitshfbc

[[ -e /root/itshfbc ]] && rm -rf /root/itshfbc
[[ -e /etc/skel/itshfbc ]] && rm -rf /etc/skel/itshfbc

./makeitshfbc && mv /root/itshfbc /etc/skel

[[ -e ${LINK_PATH} ]] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

cd ${CWD_DIR}

stow -v -d /opt ${APP} -t /usr/local
