#!/bin/bash
# GPD Pocket 3 KVM Module Display Script
# Optimized for low-latency HDMI capture with auto-detection

# Kill any existing mpv instances
pkill -9 mpv 2>/dev/null

# Auto-detect the HDMI Capture device
KVM_DEVICE=""

echo "Searching for HDMI Capture device..."

for device in /dev/video*; do
    # Skip if not a character device
    [ -c "$device" ] || continue

    # Get device info from udev
    device_info=$(udevadm info --name="$device" 2>/dev/null)

    # Look for HDMI Capture identifiers
    if echo "$device_info" | grep -qi "HDMI.*Capture"; then
        KVM_DEVICE="$device"
        echo "Found KVM capture card: $device"
        break
    fi
done

# Fallback to /dev/video2 if auto-detection fails
if [ -z "$KVM_DEVICE" ]; then
    echo "Warning: Could not auto-detect HDMI Capture device"
    if [ -c "/dev/video2" ]; then
        echo "Falling back to /dev/video2"
        KVM_DEVICE="/dev/video2"
    else
        echo "Error: No KVM capture device found!"
        echo "Available video devices:"
        ls -la /dev/video* 2>/dev/null
        exit 1
    fi
fi

echo "Launching KVM display from $KVM_DEVICE..."

# Launch mpv with optimized settings for the KVM capture card
mpv "$KVM_DEVICE" \
    --profile=low-latency \
    --untimed \
    --no-cache \
    --demuxer-lavf-analyzeduration=0.1 \
    --video-sync=audio \
    --opengl-swapinterval=0 \
    --framedrop=no \
    --fullscreen \
    --title="Server KVM - $KVM_DEVICE" \
    --geometry=100%:100% \
    --no-border \
    --ontop \
    --no-osc \
    --no-input-default-bindings \
    --input-conf=/dev/stdin <<EOF
q quit
f cycle fullscreen
m cycle mute
ESC quit
EOF
