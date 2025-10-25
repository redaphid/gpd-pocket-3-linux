#!/bin/bash
# Helper script for systemd/udev to launch KVM display
# Launches script in user's graphical session from root context

# Configuration
USER_NAME="redaphid"
USER_UID=$(id -u "$USER_NAME")
SCRIPT_PATH="/home/redaphid/Projects/pocket-3-config/kvm-display.sh"

# Small delay to ensure device is fully initialized
sleep 0.5

# Find the user's graphical session
# Look for the DISPLAY and DBUS_SESSION_BUS_ADDRESS from the user's environment
USER_DISPLAY=$(sudo -u "$USER_NAME" bash -c 'pgrep -u $(id -u) gnome-session | head -1 | xargs -I{} cat /proc/{}/environ 2>/dev/null | tr "\0" "\n" | grep "^DISPLAY=" | cut -d= -f2')
USER_DBUS=$(sudo -u "$USER_NAME" bash -c 'pgrep -u $(id -u) gnome-session | head -1 | xargs -I{} cat /proc/{}/environ 2>/dev/null | tr "\0" "\n" | grep "^DBUS_SESSION_BUS_ADDRESS=" | cut -d= -f2-')

# If we found the session variables, launch the script
if [ -n "$USER_DISPLAY" ] && [ -n "$USER_DBUS" ]; then
    sudo -u "$USER_NAME" \
        DISPLAY="$USER_DISPLAY" \
        DBUS_SESSION_BUS_ADDRESS="$USER_DBUS" \
        "$SCRIPT_PATH" &
else
    echo "ERROR: Could not find user's graphical session"  >> /var/log/kvm-auto-launch.log
    exit 1
fi

exit 0
