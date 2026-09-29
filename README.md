# hosts-updater
A script to automatically protect your `/etc/hosts` file from modifications.

Merges the custom `hosts` file with a blocklist downloaded from the specified URL.
Monitors `/etc/hosts` for changes and automatically restores your configuration if modified.

You can check a list of hosts files [here](https://github.com/StevenBlack/hosts).

## Setup

### macOS

To install the hosts updater to monitor `/etc/hosts` automatically:

```bash
sudo ./macos-setup.sh
```

This will:
- Install a launchd service that watches for changes to `/etc/hosts`
- Update your `/etc/hosts` file immediately
- Automatically restore your configuration if anyone modifies `/etc/hosts`
- Create logs in the project directory

**How it works**: Whenever `/etc/hosts` is modified (e.g., if you or an application tries to remove blocks), the script will automatically detect the change and restore your custom hosts file merged with the blocklist.

### Linux

To install the hosts updater to monitor `/etc/hosts` automatically:

```bash
sudo ./linux-setup.sh
```

## Manual Update

To manually update the hosts file at any time:

```bash
sudo ./hosts-updater.sh
```

## Testing

To verify the watcher is working:

```bash
./test-watcher.sh
```

This will monitor the logs. In another terminal, try editing `/etc/hosts`:

```bash
sudo nano /etc/hosts
```

Make any change and save. You should see the script automatically restore your configuration within seconds.

## How to Add Custom Blocks

Edit the `hosts` file in this directory to add your custom entries:

```bash
nano hosts
```

Then manually run the update:

```bash
sudo ./hosts-updater.sh
```

Your custom entries will be preserved and the blocklist will be appended.

## Uninstall

### macOS

To remove the automatic updater service:

```bash
sudo ./macos-uninstall.sh
```

### Linux

```bash
sudo systemctl stop hosts-updater.timer
sudo systemctl disable hosts-updater.timer
sudo rm /etc/systemd/system/hosts-updater.service
sudo rm /etc/systemd/system/hosts-updater.timer
sudo systemctl daemon-reload
```

## Logs

- Update logs: `hosts_update.log`
- Service logs (macOS): `launchd-stdout.log` and `launchd-stderr.log`

## Useful Commands

### macOS

Check if service is running:
```bash
sudo launchctl list | grep hostupdater
```

View recent logs:
```bash
tail -f hosts_update.log
```

### Linux

Check service status:
```bash
sudo systemctl status hosts-updater.timer
```

View logs:
```bash
sudo journalctl -u hosts-updater.service -f
```
