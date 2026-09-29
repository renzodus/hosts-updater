#!/bin/bash

# macOS Uninstall Script for Hosts Updater
# This script removes the hosts updater launchd service

set -e  # Exit on error

PLIST_DEST="/Library/LaunchDaemons/com.hostupdater.plist"

echo "=== macOS Hosts Updater Uninstall ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root (use sudo)"
    exit 1
fi

# Check if service exists
if [ ! -f "$PLIST_DEST" ]; then
    echo "Service is not installed."
    exit 0
fi

# Unload the service
echo "Unloading service..."
launchctl unload "$PLIST_DEST" 2>/dev/null || true
echo "✓ Service unloaded"

# Remove the plist file
rm "$PLIST_DEST"
echo "✓ Removed $PLIST_DEST"

# Remove the immutable flag so /etc/hosts can be edited freely again
chflags noschg /etc/hosts 2>/dev/null || true
echo "✓ Removed immutable flag from /etc/hosts"

echo ""
echo "=== Uninstall Complete ==="
echo "The hosts updater service has been removed."
echo "Note: /etc/hosts is now editable again."
echo ""
