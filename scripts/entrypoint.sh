#!/bin/bash
set -euo pipefail

# Configuration
STARTSCRIPT="${STARTSCRIPT:-startserver.sh}"
MINECRAFT_DIR="/minecraft"
EULA_FILE="${MINECRAFT_DIR}/eula.txt"

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

STARTSCRIPT_PATH="${MINECRAFT_DIR}/${STARTSCRIPT}"

# Only download and extract modpack if the start script doesn't exist
if [ ! -f "${STARTSCRIPT_PATH}" ]; then
    log_info "Start script not found at ${STARTSCRIPT_PATH}"
    
    # Check if the modpack URL is provided
    if [ -n "${MODPACK_URL:-}" ]; then
        log_info "MODPACK_URL: ${MODPACK_URL}"
        log_info "Downloading modpack from ${MODPACK_URL}..."
        
        # Download with retry logic
        MAX_RETRIES=3
        RETRY_COUNT=0
        while [ ${RETRY_COUNT} -lt ${MAX_RETRIES} ]; do
            if wget --content-disposition --progress=bar:force -P "${MINECRAFT_DIR}" "${MODPACK_URL}"; then
                log_info "Download successful"
                break
            else
                RETRY_COUNT=$((RETRY_COUNT + 1))
                if [ ${RETRY_COUNT} -lt ${MAX_RETRIES} ]; then
                    log_warn "Download failed, retrying (${RETRY_COUNT}/${MAX_RETRIES})..."
                    sleep 5
                else
                    log_error "Failed to download modpack after ${MAX_RETRIES} attempts"
                    exit 1
                fi
            fi
        done
        
        # Find the downloaded file (assumes only one zip file is downloaded)
        MODPACK_FILE=$(find "${MINECRAFT_DIR}" -maxdepth 1 -type f -name '*.zip' | head -n 1)
        if [ -z "${MODPACK_FILE}" ]; then
            log_error "Failed to find downloaded modpack file in ${MINECRAFT_DIR}"
            exit 1
        fi
        
        log_info "Found modpack file: ${MODPACK_FILE}"
        log_info "Extracting modpack..."
        
        # Extract with error handling
        if unzip -q "${MODPACK_FILE}" -d "${MINECRAFT_DIR}"; then
            log_info "Extraction successful"
            # Clean up the zip file
            rm -f "${MODPACK_FILE}"
            log_info "Cleaned up modpack archive"
        else
            log_error "Failed to extract modpack"
            exit 1
        fi
    else
        log_warn "No MODPACK_URL provided and start script not found"
    fi

    # Ensure the start script exists after extraction
    if [ ! -f "${STARTSCRIPT_PATH}" ]; then
        log_error "${STARTSCRIPT} not found at ${STARTSCRIPT_PATH}. Please ensure the modpack includes it."
        exit 1
    fi

    # Make the start script executable
    log_info "Making ${STARTSCRIPT_PATH} executable"
    chmod +x "${STARTSCRIPT_PATH}"
    
    # Automatically accept the EULA
    log_info "Accepting Minecraft EULA..."
    echo "eula=true" > "${EULA_FILE}"
else
    log_info "Server files already exist (${STARTSCRIPT} found at ${STARTSCRIPT_PATH}), skipping download"
fi

# Verify start script is executable
if [ ! -x "${STARTSCRIPT_PATH}" ]; then
    log_warn "${STARTSCRIPT_PATH} is not executable, fixing permissions..."
    chmod +x "${STARTSCRIPT_PATH}"
fi

# Run setup script in background after server files are generated
SETUP_SCRIPT="/scripts/setup.sh"
SETUP_FLAG="/minecraft/.setup_complete"

if [ -f "${SETUP_SCRIPT}" ] && [ ! -f "${SETUP_FLAG}" ]; then
    log_info "Setup script detected, will run after server initializes..."
    (
        # Wait for server.properties to be created
        log_info "Waiting for server files to be generated..."
        while [ ! -f "${MINECRAFT_DIR}/server.properties" ]; do
            sleep 5
        done
        
        # Give it a bit more time to ensure all files are created
        sleep 10
        
        log_info "Server files detected, running setup..."
        if bash "${SETUP_SCRIPT}"; then
            log_info "Setup completed successfully"
            touch "${SETUP_FLAG}"
        else
            log_error "Setup failed"
        fi
    ) &
fi

log_info "Starting Minecraft server with ${STARTSCRIPT_PATH}..."
exec /bin/bash "${STARTSCRIPT_PATH}"
