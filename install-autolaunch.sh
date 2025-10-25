#!/bin/bash
# Install script for KVM auto-launch udev rule
# This sets up automatic launching of the KVM display when the HDMI Capture device is connected

set -e

echo "Installing KVM auto-launch udev rule..."

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo:"
    echo "  sudo ./install-autolaunch.sh"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy helper script to /usr/local/bin
echo "Installing helper script..."
cp "$SCRIPT_DIR/kvm-auto-launch-helper.sh" /usr/local/bin/
chmod +x /usr/local/bin/kvm-auto-launch-helper.sh

# Copy udev rule
echo "Installing udev rule..."
cp "$SCRIPT_DIR/99-kvm-autolaunch.rules" /etc/udev/rules.d/

# Reload udev rules
echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

echo ""
echo "✓ Installation complete!"
echo ""
echo "The KVM display will now automatically launch when you connect the HDMI cable"
echo "to the KVM module."
echo ""
echo "To uninstall:"
echo "  sudo rm /etc/udev/rules.d/99-kvm-autolaunch.rules"
echo "  sudo rm /usr/local/bin/kvm-auto-launch-helper.sh"
echo "  sudo udevadm control --reload-rules"
