#!/bin/bash
# Install script for KVM auto-launch monitoring service
# This sets up automatic launching of the KVM display when the HDMI Capture device is connected

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

# Install helper script (used by both methods)
echo "Installing helper script..."
cp "$SCRIPT_DIR/kvm-auto-launch-helper.sh" /usr/local/bin/
chmod +x /usr/local/bin/kvm-auto-launch-helper.sh

# Install monitoring script
echo "Installing monitoring service..."
cp "$SCRIPT_DIR/kvm-monitor.sh" /usr/local/bin/
chmod +x /usr/local/bin/kvm-monitor.sh

# Install systemd service
echo "Installing systemd service..."
cp "$SCRIPT_DIR/kvm-monitor.service" /etc/systemd/system/

# Reload systemd and enable service
echo "Enabling KVM monitor service..."
systemctl daemon-reload
systemctl enable kvm-monitor.service
systemctl start kvm-monitor.service

echo ""
echo "✓ Installation complete!"
echo ""
echo "The KVM monitor service is now running and will:"
echo "  • Start automatically at boot"
echo "  • Watch for HDMI Capture device (3188:1000)"
echo "  • Launch KVM display when device is detected"
echo ""
echo "Service status:"
systemctl status kvm-monitor.service --no-pager -l || true
echo ""
echo "To uninstall:"
echo "  sudo systemctl stop kvm-monitor.service"
echo "  sudo systemctl disable kvm-monitor.service"
echo "  sudo rm /etc/systemd/system/kvm-monitor.service"
echo "  sudo rm /usr/local/bin/kvm-monitor.sh"
echo "  sudo rm /usr/local/bin/kvm-auto-launch-helper.sh"
echo "  sudo systemctl daemon-reload"
