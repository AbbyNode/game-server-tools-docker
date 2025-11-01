#!/bin/bash
set -euo pipefail

# first move the files to /config
mkdir -p /config
mv /minecraft/server.properties      /config/server.properties
mv /minecraft/banned-players.json    /config/banned-players.json
mv /minecraft/banned-ips.json        /config/banned-ips.json
mv /minecraft/ops.json               /config/ops.json
mv /minecraft/whitelist.json         /config/whitelist.json

# Create symbolic links for configuration files and directories to allow container directory binding
ln -sf /config/server.properties      /minecraft/server.properties
ln -sf /config/banned-players.json    /minecraft/banned-players.json
ln -sf /config/banned-ips.json        /minecraft/banned-ips.json
ln -sf /config/ops.json               /minecraft/ops.json
ln -sf /config/whitelist.json         /minecraft/whitelist.json
