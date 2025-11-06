#!/bin/bash
set -e

echo "=== Minecraft Modpack Docker - Setup & Initialization ==="
echo ""


# ========== Base Setup Files ==========

# Update docker-compose.yml with the latest version from templates
echo "Updating docker-compose.yml..."
if [[ -f /workspace/docker-compose.yml ]]; then
    timestamp=$(date +"%Y%m%d_%H%M%S")
    echo "Backing up existing docker-compose.yml to docker-compose.yml.bak_$timestamp"
    cp /workspace/docker-compose.yml /workspace/docker-compose.yml.bak_"$timestamp"
    echo "✓ Backup created"
fi
cp /templates/docker-compose.yml /workspace/docker-compose.yml
echo "✓ docker-compose.yml updated"

# Setup scripts virtual volume using /workspace/scripts
echo "Updating scripts volume..."
mkdir -p /scripts
cp -r /workspace/scripts/* /scripts/
chmod +x /scripts/*.sh
echo "✓ Scripts volume updated"


# ========== Configuration Files ==========

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
