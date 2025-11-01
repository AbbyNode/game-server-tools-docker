#!/bin/bash
set -euo pipefail

# Internal paths
MINECRAFT_DIR="/minecraft"
CONFIG_DIR="/config"
SCRIPTS_DIR="/scripts"
TEMPLATES_DIR="/templates"

# Configurable vars
: "${STARTSCRIPT:=startserver.sh}"
STARTSCRIPT_PATH="${MINECRAFT_DIR}/${STARTSCRIPT}" # If this file exists, modpack has been downloaded and extracted.

# Minecraft subdirectories
WORLD_DIR="${MINECRAFT_DIR}/world"
MODS_DIR="${MINECRAFT_DIR}/mods"
LOGS_DIR="${MINECRAFT_DIR}/logs"

# Properties files
DEFAULT_PROPS="${TEMPLATES_DIR}/default.properties"
SERVER_PROPS="${MINECRAFT_DIR}/server.properties" # If this file exists, server is ready for post-setup tasks.
LINKED_PROPS="${CONFIG_DIR}/server.properties" # If this file exists, first time setup is considered complete.

LOG_FILE="${LOGS_DIR}/modpack-setup.log"
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "${LOG_FILE}"
}
log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "${LOG_FILE}" >&2
}
log_warn() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "${LOG_FILE}" >&2
}
