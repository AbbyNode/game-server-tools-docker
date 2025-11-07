#!/bin/sh

if [ -f /run/secrets/cloudflared_token ]; then
    # Read Cloudflare token from Docker secret
    CLOUD_FLARE_TOKEN=$(cat /run/secrets/cloudflared_token)

    # Validate token format (base64 encoded JSON with required fields)
    # Unset token if invalid format
    if ! echo "$CLOUD_FLARE_TOKEN" | base64 -d | grep -q '"t"'; then
        echo "ERROR: Invalid token format"
        unset CLOUD_FLARE_TOKEN
    fi
fi

if [ -n "$CLOUD_FLARE_TOKEN" ]; then
    echo "Token found, running with token"
    cloudflared tunnel run --token "$CLOUD_FLARE_TOKEN"
else
    echo "No token found, running without token"
    cloudflared tunnel run --url 
fi
