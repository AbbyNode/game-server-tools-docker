#!/bin/bash
set -euo pipefail

# Paths
: "${SCRIPTS_DIR:=/scripts}"
: "${MINECRAFT_DIR:=/minecraft}"
: "${CONFIG_DIR:=/config}"
: "${STARTSCRIPT:=startserver.sh}"
: "${STARTSCRIPT_PATH:=${MINECRAFT_DIR}/${STARTSCRIPT}}"

# If this file exists, server is ready for post-setup
READY_FOR_SETUP_FLAG="${MINECRAFT_DIR}/server.properties"

# If this file exists, first time setup is considered complete
SETUP_COMPLETE_FLAG="${CONFIG_DIR}/server.properties"

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}
log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}
log_warn() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}
