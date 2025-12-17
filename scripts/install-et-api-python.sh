#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 16 December 2025
# Purpose : Install EmComm Tools API (Python version)
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh
. ../overlay/opt/emcomm-tools/bin/et-common

APP=et-api
VERSION=1.0.0
BASE_URL="https://github.com/jflozanor/et-api-python/releases/download/${VERSION}"

INSTALL_DIR="/opt/emcomm-tools-api"
BIN_DIR="${INSTALL_DIR}/bin"
DATA_DIR="${INSTALL_DIR}/data"
INDEX_DIR="${INSTALL_DIR}/index"
VENV_DIR="${INSTALL_DIR}/venv"

et-log "Installing ${APP} ${VERSION} (Python)..."

# Ensure Python 3.11+ is available
if ! command -v python3.11 &> /dev/null; then
    et-log "Installing Python 3.11..."
    apt install -y python3.11 python3.11-venv python3-pip
fi

mkdir -v -p "${BIN_DIR}" "${DATA_DIR}" "${INDEX_DIR}"

# Create virtual environment
et-log "Creating Python virtual environment..."
python3.11 -m venv "${VENV_DIR}"

# Install et-api package
et-log "Installing et-api Python package..."
"${VENV_DIR}/bin/pip" install --upgrade pip
"${VENV_DIR}/bin/pip" install "et-api @ git+https://github.com/jflozanor/et-api-python.git@${VERSION}"

# Create wrapper script
et-log "Creating wrapper script..."
cat > "${BIN_DIR}/${APP}" << 'EOF'
#!/bin/bash
# EmComm Tools API launcher
exec /opt/emcomm-tools-api/venv/bin/python -m uvicorn et_api.main:app --host 0.0.0.0 --port 1981
EOF
chmod 755 "${BIN_DIR}/${APP}"

# Download pre-built data sets
FILES=(
  "faa.csv"
  "license.csv"
  "zip2geo.csv"
  "zip2geo-elevation.csv"
)
for file in "${FILES[@]}"; do
  URL="${BASE_URL}/${file}"

  et-log "Downloading data set: ${URL}"
  download_with_retries ${URL} ${file}
  mv ${file} ${DATA_DIR}
done

# Build search indexes
et-log "Building search indexes..."
"${VENV_DIR}/bin/python" -m et_api.db.indexer

et-log "Applying permissions..."
chgrp -v -R ${ET_GROUP} ${DATA_DIR} ${INDEX_DIR}
chmod -v 775 ${DATA_DIR} ${INDEX_DIR}
chmod -v 664 ${DATA_DIR}/*.csv

et-log "${APP} ${VERSION} (Python) installation complete."
