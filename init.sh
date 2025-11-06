#!/bin/bash
set -e

echo "=== Minecraft Modpack Docker - Setup & Initialization ==="
echo ""

WORKSPACE="/workspace"
SETUP="/setup"
TEMPLATES="/templates"
SCRIPTS_SRC="/scripts-src"
SCRIPTS_VOL="/scripts"

# TODO: use above variables across this script

# ========== Base Setup Files ==========

# Update docker-compose.yml with the latest version
echo "Updating docker-compose.yml..."
if [[ -f /workspace/docker-compose.yml ]]; then
    timestamp=$(date +"%Y%m%d_%H%M%S")
    echo "Backing up existing docker-compose.yml to docker-compose.yml.bak_$timestamp"
    cp /workspace/docker-compose.yml /workspace/docker-compose.yml.bak_"$timestamp"
    echo "✓ Backup created"
fi
cp /setup/docker-compose.yml /workspace/docker-compose.yml
echo "✓ docker-compose.yml updated"

# Setup scripts virtual volume
echo "Updating scripts volume..."
mkdir -p /scripts
cp -r /scripts-src/* /scripts/
chmod +x /scripts/*.sh
echo "✓ Scripts volume updated"


# ========== Configuration Files ==========

# Loop all files recursively in /templates/config and ensure they exist
echo "Syncing configuration files from templates..."
if [[ -d /templates/config ]]; then
    find /templates/config -type f | while read -r template_file; do
        relative_path="${template_file#/templates/config/}"
        target_file="/workspace/$relative_path"
        target_dir=$(dirname "$target_file")
        
        if [[ ! -f "$target_file" ]]; then
            mkdir -p "$target_dir"
            cp "$template_file" "$target_file"
            echo "✓ Created $relative_path"
        fi
    done
fi

# Create .env file if it doesn't exist
if [[ ! -f /workspace/.env ]]; then
    echo "Creating .env from template..."
    cp /templates/.env.example /workspace/.env
    echo "✓ .env created"
else
    echo "✓ .env already exists"
fi

# Create .secrets file if it doesn't exist
if [[ ! -f /workspace/.secrets ]]; then
    echo "Creating .secrets from template..."
    cp /templates/.secrets.example /workspace/.secrets
    echo "✓ .secrets created"
else
    echo "✓ .secrets already exists"
fi

# Create mcaselector-options.yaml if it doesn't exist
if [[ ! -f /workspace/config/mcaselector/mcaselector-options.yaml ]]; then
    echo "Creating mcaselector-options.yaml from template..."
    mkdir -p /workspace/config/mcaselector
    cp /templates/mcaselector-options.yaml /workspace/config/mcaselector/mcaselector-options.yaml
    echo "✓ mcaselector-options.yaml created"
else
    echo "✓ mcaselector-options.yaml already exists"
fi


echo ""
echo "=== Setup Complete ==="
echo ""
echo "You can now start the services with: docker compose up -d"
