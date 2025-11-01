
# Link any existing .json files
for file in "${CONFIG_DIR}"/*.json; do
    log_info "Linking $(basename "$file") to Minecraft directory..."
    ln -sf "$file" "${MINECRAFT_DIR}/$(basename "$file")"
done

# Set proper permissions
log_info "Setting permissions..."
chmod -R 755 "${MINECRAFT_DIR}" 2>/dev/null || true
chmod 644 "${MINECRAFT_DIR}"/*.json 2>/dev/null || true
