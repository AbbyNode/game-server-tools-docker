#!/bin/bash
set -e

echo "=== Minecraft Modpack Docker - Setup & Initialization ==="
echo ""


# ========== Paths ==========

WORKSPACE="/workspace"
SETUP="/setup"
TEMPLATES="/templates"
SCRIPTS_SRC="/scripts-src"
SCRIPTS_VOL="/scripts"


# =========== Helper Functions ==========

function ask_replace() {
    local src_file="$1"
    local dest_file="$2"

    echo "Updating $(basename "$dest_file")..."
    if [[ -f "$dest_file" ]]; then
        read -p "$dest_file already exists. Overwrite? (y/n): " choice
        if [[ $choice == "y" ]]; then
            cp "$src_file" "$dest_file"
            echo "✓ Replaced $(basename "$dest_file")"
        else
            echo "✓ Skipped $(basename "$dest_file")"
        fi
    else
        mkdir -p "$(dirname "$dest_file")"
        cp "$src_file" "$dest_file"
        echo "✓ Created $(basename "$dest_file")"
    fi
}


# ========== Docker compose ==========

cp "$SETUP/docker-compose.yml" "$WORKSPACE/docker-compose.yml"


# ========== Scripts Volume ==========

echo "Updating scripts volume..."
mkdir -p "$SCRIPTS_VOL"
cp -r "$SCRIPTS_SRC/"* "$SCRIPTS_VOL/"
chmod +x "$SCRIPTS_VOL/"**/*.sh
echo "✓ Scripts volume updated"


# ========== Configuration Files ==========

# Ensure all files from $TEMPLATES exist in $WORKSPACE
echo "Adding missing templates..."
if [[ ! -d $TEMPLATES ]]; then
	echo "ERROR: No templates found!"
fi

for template_file in $(find "$TEMPLATES" -type f); do
    relative_path="${template_file#$TEMPLATES/}"
    target_file="${WORKSPACE}/${relative_path}"
    ask_replace "$template_file" "$target_file"
done


echo ""
echo "=== Setup Complete ==="
echo ""
echo "You can now start the services with: docker compose up -d"
