#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

# Check if modpack download is needed
if [ -f "${STARTSCRIPT_PATH}" ]; then
    log_info "Server files already exist (${STARTSCRIPT} found), skipping download"
    exit 0
fi

log_info "Start script not found at ${STARTSCRIPT_PATH}"

if [ -z "${MODPACK_URL:-}" ]; then
    log_warn "No MODPACK_URL provided and start script not found"
    exit 1
fi

# Download modpack
log_info "Downloading modpack from ${MODPACK_URL}..."
wget --content-disposition --progress=bar:force -P "${MINECRAFT_DIR}" "${MODPACK_URL}"
log_info "Download successful"

# Find and extract the downloaded file
MODPACK_FILE=$(find "${MINECRAFT_DIR}" -maxdepth 1 -type f -name '*.zip' | head -n 1)
if [ -z "${MODPACK_FILE}" ]; then
    log_error "Failed to find downloaded modpack file in ${MINECRAFT_DIR}"
    exit 1
fi

log_info "Extracting modpack from ${MODPACK_FILE}..."
if unzip -q "${MODPACK_FILE}" -d "${MINECRAFT_DIR}"; then
    log_info "Extraction successful"
    rm -f "${MODPACK_FILE}"
    log_info "Cleaned up modpack archive"
else
    log_error "Failed to extract modpack"
    exit 1
fi

# Verify start script exists and make executable
if [ ! -f "${STARTSCRIPT_PATH}" ]; then
    log_error "${STARTSCRIPT} not found at ${STARTSCRIPT_PATH}"
    exit 1
fi

ensure_executable "${STARTSCRIPT_PATH}"
log_info "Modpack setup complete"
