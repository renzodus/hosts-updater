#!/bin/bash

# Test script to verify the hosts file watcher is working correctly

echo "=== Hosts File Watcher Test ==="
echo ""
echo "This script will test if the launchd service detects changes to /etc/hosts"
echo ""

# Check if service is loaded
if sudo launchctl list | grep -q "com.hostupdater"; then
    echo "✓ Service is loaded and running"
else
    echo "✗ Service is not loaded. Run 'sudo ./macos-setup.sh' first"
    exit 1
fi

echo ""
echo "Monitoring logs... (press Ctrl+C to stop)"
echo "In another terminal, try: sudo nano /etc/hosts"
echo "Make a change and save. You should see the script run automatically."
echo ""
echo "--- Watching hosts_update.log ---"
echo ""

# Tail the log file
tail -f hosts_update.log
