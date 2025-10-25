#!/bin/bash
# Helper script for udev to launch KVM display
# This script finds the active user session and launches the KVM display

# Find the active user and their display
USER_NAME="redaphid"
DISPLAY_NUM=":0"

# Get the user's DBUS session
DBUS_SESSION=$(ps -u "$USER_NAME" e | grep -Eo 'dbus-daemon.*address=unix:abstract=/tmp/dbus-[A-Za-z0-9]{10}' | tail -n 1 | grep -Eo 'unix:abstract=/tmp/dbus-[A-Za-z0-9]{10}')

if [ -z "$DBUS_SESSION" ]; then
    # Fallback: try to find DBUS_SESSION_BUS_ADDRESS from environment
    DBUS_SESSION=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u "$USER_NAME" gnome-session | head -n1)/environ 2>/dev/null | cut -d= -f2-)
fi

# Launch the KVM display script as the user
export DISPLAY="$DISPLAY_NUM"
export DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION"
export XAUTHORITY="/home/$USER_NAME/.Xauthority"

# Small delay to ensure device is ready
sleep 1

# Launch as the user
su - "$USER_NAME" -c "DISPLAY=$DISPLAY_NUM DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION /home/redaphid/Projects/pocket-3-config/kvm-display.sh" &

exit 0
