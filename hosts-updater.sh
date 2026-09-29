#!/bin/bash

# Hosts File Updater Script
# This script updates /etc/hosts with a base file and downloaded blocklist

set -e  # Exit on error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_HOSTS="$SCRIPT_DIR/hosts"
BLOCKLIST_URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"
TEMP_HOSTS="/tmp/hosts.tmp"
LOG_FILE="$SCRIPT_DIR/hosts_update.log"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Check if base hosts file exists
if [ ! -f "$BASE_HOSTS" ]; then
    log "ERROR: Base hosts file not found at $BASE_HOSTS"
    exit 1
fi

log "Starting hosts file update..."

# Copy base hosts file to temp location
cp "$BASE_HOSTS" "$TEMP_HOSTS"
log "Copied base hosts file"

# Download and append blocklist
log "Downloading blocklist from $BLOCKLIST_URL"
if curl -fsSL "$BLOCKLIST_URL" >> "$TEMP_HOSTS"; then
    log "Successfully downloaded and appended blocklist"
else
    log "ERROR: Failed to download blocklist"
    rm -f "$TEMP_HOSTS"
    exit 1
fi

# Check if the new hosts file is different from the current one
if cmp -s "$TEMP_HOSTS" /etc/hosts; then
    log "Hosts file is already up to date, no changes needed"
    rm -f "$TEMP_HOSTS"
    exit 0
fi

# Backup current /etc/hosts
cp /etc/hosts /etc/hosts.backup
log "Backed up current /etc/hosts to /etc/hosts.backup"

# Remove immutable flag before replacing (in case it was set previously)
chflags noschg /etc/hosts 2>/dev/null || true

# Replace /etc/hosts with new version
mv "$TEMP_HOSTS" /etc/hosts
chmod 644 /etc/hosts
log "Successfully updated /etc/hosts"

# Lock the file so it can't be edited without explicitly removing the flag first
chflags schg /etc/hosts
log "Set system immutable flag on /etc/hosts (chflags schg)"

log "Hosts file update completed successfully"
log "To edit /etc/hosts manually, first run: sudo chflags noschg /etc/hosts"