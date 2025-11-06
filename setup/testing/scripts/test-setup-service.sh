#!/usr/bin/env bash
# Tests for setup service initialization

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source test framework
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../lib/test-framework.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../lib/docker-utils.sh"

test_suite "Setup Service - Script Structure"

# Test setup script exists and is valid
test_setup_script_structure() {
    local init_script="$PROJECT_ROOT/setup/scripts/init.sh"
    
    assert_file_exists "$init_script" "init.sh exists"
    assert_true "[ -x '$init_script' ]" "init.sh is executable"
    
    # Check for key operations in the script
    assert_true "grep -q '\\.env' '$init_script'" "Script handles .env file"
}

test_setup_script_structure

test_suite "Setup Service - Templates"

# Test that required templates exist
test_setup_templates() {
    local templates_dir="$PROJECT_ROOT/setup/templates"
    
    assert_dir_exists "$templates_dir" "Templates directory exists"
    assert_file_exists "$templates_dir/.env.example" ".env.example template exists"
    
    # Check .env.example has required variables
    local env_example="$templates_dir/.env.example"
    assert_true "grep -q 'MODPACK_URL' '$env_example'" ".env.example contains MODPACK_URL"
    assert_true "grep -q 'BORG_PASSPHRASE' '$env_example'" ".env.example contains BORG_PASSPHRASE"
    
    # No Ofelia configuration required
}

test_setup_templates

test_suite "Setup Service - Dockerfile"

# Test setup Dockerfile
test_setup_dockerfile() {
    local dockerfile="$PROJECT_ROOT/setup/Dockerfile"
    
    assert_file_exists "$dockerfile" "Setup Dockerfile exists"
    
    # Check Dockerfile structure
    assert_true "grep -q 'FROM alpine' '$dockerfile'" "Uses Alpine base image"
    assert_true "grep -q 'COPY.*templates' '$dockerfile'" "Copies templates"
    assert_true "grep -q 'COPY.*scripts' '$dockerfile'" "Copies scripts"
    assert_true "grep -q 'ENTRYPOINT.*init.sh' '$dockerfile'" "Sets init.sh as entrypoint"
}

test_setup_dockerfile

print_summary
