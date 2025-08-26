#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 6 July 2025
# Purpose  : Downloads pre-rendered raster map tiles in mbtile format

BASE_URL="https://github.com/thetechprepper/emcomm-tools-os-community/releases/download"
RELEASE="emcomm-tools-os-community-20250401-r4-final-4.0.0"
TILESET_DIR="/etc/skel/.local/share/emcomm-tools/mbtileserver/tilesets"

OPTIONS=(
  "us" "United States"
  "ca" "Canada"
)

SELECTED_COUNTRY=$(dialog --clear --menu "Select a country" 15 40 5 "${OPTIONS[@]}"  2>&1 >/dev/tty)
EXIT_STATUS=$?

tput sgr 0 && clear

if [[ $EXIT_STATUS -eq 0 ]]; then
  DOWNLOAD_FILE="osm-${SELECTED_COUNTRY}-zoom0to10-20250703.mbtiles"
  DOWNLOAD_URL="${BASE_URL}/${RELEASE}/${DOWNLOAD_FILE}"

  if [[ ! -e ${DOWNLOAD_FILE} ]]; then
    et-log "Downloading ${DOWNLOAD_URL}"
    curl -L -f -o ${DOWNLOAD_FILE} ${DOWNLOAD_URL}
  fi

  et-log "Moving ${DOWNLOAD_FILE} ${TILESET_DIR}"
  mv -v ${DOWNLOAD_FILE} ${TILESET_DIR}
fi
