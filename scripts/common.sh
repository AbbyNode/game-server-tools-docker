#!/bin/bash

# Common functions and constants
set -euo pipefail

# Paths
: "${SCRIPTS_DIR:=/scripts}"
: "${MINECRAFT_DIR:=/minecraft}"
: "${STARTSCRIPT:=startserver.sh}"
: "${STARTSCRIPT_PATH:=${MINECRAFT_DIR}/${STARTSCRIPT}}"

# Logging functions
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_warn() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# Ensure executable permissions
ensure_executable() {
    local file="$1"
    if [ ! -x "$file" ]; then
        log_warn "$file is not executable, fixing permissions..."
        chmod +x "$file"
    fi
}
