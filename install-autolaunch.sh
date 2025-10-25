#!/bin/bash
# Install script for KVM auto-launch via udev + systemd
# This sets up event-driven launching of the KVM display when the HDMI Capture device is disconnected

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

# Install helper script
echo "Installing helper script..."
cp "$SCRIPT_DIR/kvm-auto-launch-helper.sh" /usr/local/bin/
chmod +x /usr/local/bin/kvm-auto-launch-helper.sh

# Install systemd service template
echo "Installing systemd service..."
cp "$SCRIPT_DIR/kvm-display-auto@.service" /etc/systemd/system/

# Install udev rule
echo "Installing udev rule..."
cp "$SCRIPT_DIR/99-kvm-autolaunch.rules" /etc/udev/rules.d/

# Reload systemd and udev
echo "Reloading systemd and udev..."
systemctl daemon-reload
udevadm control --reload-rules
udevadm trigger

echo ""
echo "✓ Installation complete!"
echo ""
echo "The KVM auto-launch is now active and will:"
echo "  • Trigger instantly when HDMI Capture device (3188:1000) is REMOVED"
echo "  • Launch KVM display automatically when you disconnect from the server"
echo "  • Event-driven via udev + systemd (no polling or background processes)"
echo ""
echo "Test by disconnecting the HDMI cable from the server to the KVM module."
echo ""
echo "To uninstall:"
echo "  sudo rm /etc/udev/rules.d/99-kvm-autolaunch.rules"
echo "  sudo rm /etc/systemd/system/kvm-display-auto@.service"
echo "  sudo rm /usr/local/bin/kvm-auto-launch-helper.sh"
echo "  sudo udevadm control --reload-rules"
echo "  sudo systemctl daemon-reload"
