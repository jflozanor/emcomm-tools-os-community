#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 16 December 2025
# Purpose : Test et-api Python installation

INSTALL_DIR="/opt/emcomm-tools-api"

# Check data files
FILES=(
  "faa.csv"
  "license.csv"
  "zip2geo.csv"
  "zip2geo-elevation.csv"
)

for file in "${FILES[@]}"; do
  if [[ ! -f "${INSTALL_DIR}/data/${file}" ]]; then
    echo -e "\t* Required file '${file}' does not exist."
    exit 1
  fi
done

# Check launcher script
if [[ ! -x "${INSTALL_DIR}/bin/et-api" ]]; then
  echo -e "\t* Launcher script not found or not executable."
  exit 1
fi

# Check virtual environment
if [[ ! -d "${INSTALL_DIR}/venv" ]]; then
  echo -e "\t* Python virtual environment not found."
  exit 1
fi

# Check et_api package is installed
if ! "${INSTALL_DIR}/venv/bin/python" -c "import et_api" 2>/dev/null; then
  echo -e "\t* et_api package not installed in virtual environment."
  exit 1
fi

# Check database exists
if [[ ! -f "${INSTALL_DIR}/index/et-api.db" ]]; then
  echo -e "\t* Database not found. Run indexer to build it."
  exit 1
fi

echo "et-api Python installation verified successfully."
exit 0
