#!/bin/bash
# Helper script for systemd/udev to launch KVM display
# This script uses systemd-run to launch in the user's graphical session

# Configuration
USER_NAME="redaphid"
USER_UID=$(id -u "$USER_NAME")
SCRIPT_PATH="/home/redaphid/Projects/pocket-3-config/kvm-display.sh"

# Small delay to ensure device is fully initialized
sleep 0.5

# Use systemd-run to launch in user session
# This properly inherits the graphical environment
systemd-run --machine="$USER_NAME@.host" \
    --user \
    --scope \
    --collect \
    --unit=kvm-display-manual \
    "$SCRIPT_PATH"

exit 0
