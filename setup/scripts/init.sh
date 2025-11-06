#!/bin/bash
set -e

echo "=== Minecraft Modpack Docker - Setup & Initialization ==="
echo ""

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

# Copy ofelia script to /shared-scripts
if [[ ! -f /shared-scripts/ofelia-entrypoint.sh ]]; then
    echo ""
    echo "Copying ofelia entrypoint script to /shared-scripts/..."
    cp /scripts/ofelia-entrypoint.sh /shared-scripts/ofelia-entrypoint.sh
    chmod +x /shared-scripts/ofelia-entrypoint.sh
    echo "✓ ofelia-entrypoint.sh copied to /shared-scripts/"
fi

# Create ofelia config if it doesn't exist
if [[ ! -f /workspace/data/config/ofelia/config.ini ]]; then
    echo ""
    echo "Creating ofelia configuration..."
    mkdir -p /workspace/data/config/ofelia
    cp /templates/ofelia-config.ini /workspace/data/config/ofelia/config.ini
    echo "✓ Ofelia config created at data/config/ofelia/config.ini"
fi

# Create required directories
echo ""
echo "Creating required directories..."
dirs=(
    /workspace/data/world
    /workspace/data/logs
    /workspace/data/config
    /workspace/data/mods/jars
    /workspace/data/mods/config
)
for dir in "${dirs[@]}"; do
    mkdir -p "$dir"
done
echo "✓ Directory structure created"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "You can now start the services with: docker compose up -d"
