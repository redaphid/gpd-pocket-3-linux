#!/bin/bash
# Helper script for systemd/udev to launch KVM display
# Triggers user systemd service which runs in the graphical session

# Configuration
USER_NAME="redaphid"
USER_UID=$(id -u "$USER_NAME")

# Small delay to ensure device is fully initialized
sleep 0.5

# Use machinectl to start the user service
# This properly runs the service in the user's systemd --user instance
# which automatically has WAYLAND_DISPLAY, XDG_RUNTIME_DIR, DBUS_SESSION_BUS_ADDRESS, etc.
machinectl shell "$USER_NAME@.host" /usr/bin/systemctl --user start kvm-display-user.service

exit 0
