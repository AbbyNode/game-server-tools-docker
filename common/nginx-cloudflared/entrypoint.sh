
#!/bin/bash
set -e


# This image makes it easy to run cloudflared tunnels with env var options

# Remotely-managed tunnel
# A remotely-managed tunnel is a tunnel that was created in Cloudflare One ↗ under Networks > Tunnels. Tunnel configuration is stored in Cloudflare, which allows you to manage the tunnel from the dashboard or using the API.

# Locally-managed tunnel
# A locally-managed tunnel is a tunnel that was created by running cloudflared tunnel create <NAME> on the command line. Tunnel configuration is stored in your local cloudflared directory. For terminology specific to locally-managed tunnels, refer to the Locally-managed tunnel glossary.

# Quick tunnels
# Quick tunnels, when run, will generate a URL that consists of a random subdomain of the website trycloudflare.com, and point traffic to localhost on port 8080. If you have a web service running at that address, users who visit the generated subdomain will be able to visit your web service through Cloudflare's network. Refer to TryCloudflare for more information on how to run quick tunnels.


# If a CLOUD_FLARE_TOKEN is provided, mode will be set to remotely-managed
# If a ???, mode will be set to locally-managed
# Otherwise, mode will be set to quick



# Simple cloudflared tunnel manager
# Two modes: Quick tunnel (trycloudflare.com) or Custom domain tunnel

# Default values
LOCAL_URL="${LOCAL_URL:-localhost:8080}"
PROTOCOL="${PROTOCOL:-http}"

# Function to show usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Environment variables:"
    echo "  QUICK_MODE=true          Force quick tunnel mode (optional)"
    echo "  DOMAIN=example.com       Your domain (required for custom tunnel)"
    echo "  SUBDOMAIN=app            Subdomain for your domain (required for custom tunnel)"
    echo "  LOCAL_URL=host:port      Local service address (default: localhost:8080)"
    echo "  PROTOCOL=http/https      Protocol (default: http)"
    echo ""
    echo "Examples:"
    echo "  # Quick tunnel"
    echo "  $0"
    echo "  QUICK_MODE=true $0"
    echo ""
    echo "  # Custom domain tunnel"
    echo "  DOMAIN=example.com SUBDOMAIN=api $0"
    echo "  DOMAIN=mydomain.com SUBDOMAIN=app LOCAL_URL=localhost:3000 $0"
    echo "  DOMAIN=test.com SUBDOMAIN=web LOCAL_URL=127.0.0.1:8000 PROTOCOL=https $0"
}

# Function to validate domain format
validate_domain() {
    local domain="$1"
    if [[ ! "$domain" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Error: Invalid domain format: $domain"
        exit 1
    fi
}

# Function to validate subdomain format
validate_subdomain() {
    local subdomain="$1"
    if [[ ! "$subdomain" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
        echo "Error: Invalid subdomain format: $subdomain"
        exit 1
    fi
}

# Function to validate local URL format
validate_local_url() {
    local url="$1"
    if [[ ! "$url" =~ ^[a-zA-Z0-9._-]+:[0-9]{1,5}$ ]]; then
        echo "Error: Invalid local URL format: $url (expected: host:port)"
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# Validate inputs
validate_local_url "$LOCAL_URL"

# Determine tunnel mode
if [ "$QUICK_MODE" = "true" ] || [ -z "$DOMAIN" ] || [ -z "$SUBDOMAIN" ]; then
    MODE="quick"
    echo "🔷 Mode: Quick tunnel"
    echo "   Local URL: $LOCAL_URL"
    echo "   Protocol: $PROTOCOL"
    echo ""
    
    # Run quick tunnel
    cloudflared tunnel --url "${PROTOCOL}://${LOCAL_URL}"
    
else
    MODE="custom"
    validate_domain "$DOMAIN"
    validate_subdomain "$SUBDOMAIN"
    
    FULL_DOMAIN="${SUBDOMAIN}.${DOMAIN}"
    
    echo "🔶 Mode: Custom domain tunnel"
    echo "   Domain: $FULL_DOMAIN"
    echo "   Local URL: $LOCAL_URL"
    echo "   Protocol: $PROTOCOL"
    echo ""
    
    # Check if cloudflared is authenticated and has access to the domain
    echo "Checking domain access..."
    if ! cloudflared tunnel list > /dev/null 2>&1; then
        echo "⚠️  Please make sure cloudflared is authenticated:"
        echo "   cloudflared tunnel login"
        exit 1
    fi
    
    # Run custom domain tunnel
    echo "Starting tunnel: $FULL_DOMAIN → ${PROTOCOL}://${LOCAL_URL}"
    cloudflared tunnel --hostname "$FULL_DOMAIN" --url "${PROTOCOL}://${LOCAL_URL}"
fi
