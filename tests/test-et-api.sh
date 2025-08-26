#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 13 August 2025
# Updated : 20 August 2025
# Purpose : Test et-api installation

FILES=(
  "faa.csv"
  "license.csv"
  "zip2geo.csv"
  "zip2geo-elevation.csv"
)

for file in "${FILES[@]}"; do
  OUT=$(ls /opt/emcomm-tools-api/data/${file} 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    echo -e "\t* Required file '$file' does not exist."
    exit 1
  fi
done

OUT=$(ls /opt/emcomm-tools-api/bin/et-api 2>/dev/null)
exit $?
