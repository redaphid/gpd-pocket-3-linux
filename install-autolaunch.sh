#!/bin/bash
# Install script for KVM auto-launch via udev + systemd
# This sets up event-driven launching of the KVM display when using Pocket 3 as KVM

set -e

echo "KVM Auto-Launch Installer"
echo "=========================="
echo ""

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo:"
    echo "  sudo ./install-autolaunch.sh"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Clean up old files/services first
echo "Cleaning up old installations..."

# Stop and disable old polling-based monitor service if it exists
if systemctl is-enabled kvm-monitor.service 2>/dev/null; then
    echo "  Disabling old kvm-monitor.service..."
    systemctl stop kvm-monitor.service 2>/dev/null || true
    systemctl disable kvm-monitor.service 2>/dev/null || true
fi

# Remove old files
rm -f /etc/systemd/system/kvm-monitor.service
rm -f /usr/local/bin/kvm-monitor.sh
rm -f /etc/udev/rules.d/99-kvm-autolaunch.rules.old

echo "  Old files removed (if any existed)"

# Install helper script
echo "Installing helper script..."
cp "$SCRIPT_DIR/kvm-auto-launch-helper.sh" /usr/local/bin/
chmod +x /usr/local/bin/kvm-auto-launch-helper.sh

# Install systemd USER service (runs in user's graphical session)
echo "Installing user systemd service..."
USER_SYSTEMD_DIR="/home/redaphid/.config/systemd/user"
mkdir -p "$USER_SYSTEMD_DIR"
cp "$SCRIPT_DIR/kvm-display-user.service" "$USER_SYSTEMD_DIR/"
chown -R redaphid:redaphid "$USER_SYSTEMD_DIR"

# Install systemd SYSTEM service template (triggered by udev)
echo "Installing system systemd service..."
cp "$SCRIPT_DIR/kvm-display-auto@.service" /etc/systemd/system/

# Install udev rule
echo "Installing udev rule..."
cp "$SCRIPT_DIR/99-kvm-autolaunch.rules" /etc/udev/rules.d/

# Reload systemd and udev
echo "Reloading systemd and udev..."
systemctl daemon-reload
sudo -u redaphid systemctl --user daemon-reload
udevadm control --reload-rules
udevadm trigger

echo ""
echo "✓ Installation complete!"
echo ""
echo "The KVM auto-launch is now active and will trigger when EITHER:"
echo "  • HDMI Capture device connects (3188:1000)"
echo "  • Pocket 3 keyboard disconnects (258a:000c)"
echo ""
echo "Launches KVM display automatically when you use the Pocket 3 as a KVM."
echo "Event-driven via udev + systemd (no polling or background processes)."
echo ""
echo "Test by connecting the Pocket 3 to a server via the KVM module."
echo ""
echo "To uninstall:"
echo "  sudo rm /etc/udev/rules.d/99-kvm-autolaunch.rules"
echo "  sudo rm /etc/systemd/system/kvm-display-auto@.service"
echo "  sudo rm /usr/local/bin/kvm-auto-launch-helper.sh"
echo "  sudo udevadm control --reload-rules"
echo "  sudo systemctl daemon-reload"
