#!/bin/bash

# macOS Setup Script for Hosts Updater
# This script installs the hosts updater as a launchd service to run every 5 minutes

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST_SOURCE="$SCRIPT_DIR/com.hostupdater.plist"
PLIST_DEST="/Library/LaunchDaemons/com.hostupdater.plist"
UPDATER_SCRIPT="$SCRIPT_DIR/hosts-updater.sh"

echo "=== macOS Hosts Updater Setup ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root (use sudo)"
    exit 1
fi

# Check if updater script exists and is executable
if [ ! -f "$UPDATER_SCRIPT" ]; then
    echo "ERROR: hosts-updater.sh not found at $UPDATER_SCRIPT"
    exit 1
fi

# Make sure the updater script is executable
chmod +x "$UPDATER_SCRIPT"
echo "✓ Made hosts-updater.sh executable"

# Check if plist file exists
if [ ! -f "$PLIST_SOURCE" ]; then
    echo "ERROR: com.hostupdater.plist not found at $PLIST_SOURCE"
    exit 1
fi

# Unload existing service if it exists
if [ -f "$PLIST_DEST" ]; then
    echo "Found existing service, unloading..."
    launchctl unload "$PLIST_DEST" 2>/dev/null || true
    echo "✓ Unloaded existing service"
fi

# Copy plist to LaunchDaemons
cp "$PLIST_SOURCE" "$PLIST_DEST"
chmod 644 "$PLIST_DEST"
chown root:wheel "$PLIST_DEST"
echo "✓ Installed plist to $PLIST_DEST"

# Load the service
launchctl load "$PLIST_DEST"
echo "✓ Loaded service"

# Check service status
if launchctl list | grep -q "com.hostupdater"; then
    echo "✓ Service is running"
else
    echo "WARNING: Service may not have started correctly"
fi

echo ""
echo "=== Setup Complete ==="
echo "The service is now monitoring /etc/hosts for changes."
echo ""
echo "Two layers of protection are active:"
echo "  1. /etc/hosts is locked with 'chflags schg' — vim/nano cannot save changes"
echo "     even with sudo, without first running: sudo chflags noschg /etc/hosts"
echo "  2. WatchPaths watcher — if the file is modified anyway, it is automatically restored."
echo ""
echo "To update the blocklist manually:"
echo "  sudo $SCRIPT_DIR/hosts-updater.sh"
echo ""
echo "Useful commands:"
echo "  - Check status: sudo launchctl list | grep hostupdater"
echo "  - View logs: cat $SCRIPT_DIR/hosts_update.log"
echo "  - Uninstall: sudo $SCRIPT_DIR/macos-uninstall.sh"
echo ""
