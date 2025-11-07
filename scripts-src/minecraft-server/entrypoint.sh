#!/bin/bash
set -euo pipefail

# CurseForge modpack entrypoint: resolves CurseForge page URLs to direct server file URLs,
# then starts the Minecraft server via itzg entrypoint.
#
# Usage (with MODPACK_URL environment variable):
#   MODPACK_URL=https://www.curseforge.com/minecraft/modpacks/all-the-mods-10
#   Or: MODPACK_URL=https://mediafilez.forgecdn.net/files/.../ServerFiles.zip

# Load logging functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/log.sh" ]; then
    # shellcheck disable=SC1091
    source "$SCRIPT_DIR/log.sh"
fi

# Validate that MODPACK_URL is set
if [ -z "${MODPACK_URL:-}" ]; then
    log_error "MODPACK_URL environment variable is required"
    exit 1
fi

# Check if URL needs resolution (CurseForge page URL)
if echo "${MODPACK_URL}" | grep -qE '^https?://(www\.)?curseforge\.com/minecraft/modpacks/[a-zA-Z0-9_-]+/?$'; then
    log_info "Detected CurseForge modpack page URL, resolving to server files..."
    
    # Use the separate resolver script
    RESOLVED_URL=$("$SCRIPT_DIR/resolve-server-pack.sh" "${MODPACK_URL}")
    
    if [ -z "$RESOLVED_URL" ]; then
        log_error "Failed to resolve server pack URL"
        exit 1
    fi
    
    log_info "Resolved to: ${RESOLVED_URL}"
    export GENERIC_PACK="${RESOLVED_URL}"
else
    log_info "Using direct URL: ${MODPACK_URL}"
    export GENERIC_PACK="${MODPACK_URL}"
fi

log_info "Starting itzg/minecraft-server..."
exec /start
