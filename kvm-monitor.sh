#!/bin/bash
# KVM Monitor Service - Watches for HDMI Capture device and launches display
# This service runs at boot and continuously monitors for USB device connections

VENDOR_ID="3188"
PRODUCT_ID="1000"
CHECK_INTERVAL=3

echo "KVM Monitor started - watching for XF HDMI Capture (${VENDOR_ID}:${PRODUCT_ID})"

# Function to check if KVM display is already running
is_kvm_running() {
    pgrep -f "mpv.*video.*low-latency" > /dev/null
}

# Function to check if HDMI Capture device is connected and has video device
has_video_device() {
    # Check if USB device exists
    if ! lsusb -d "${VENDOR_ID}:${PRODUCT_ID}" > /dev/null 2>&1; then
        return 1
    fi

    # Check if video device exists with this vendor/product
    for dev in /sys/class/video4linux/video*/device; do
        if [ -e "$dev/idVendor" ] && [ -e "$dev/idProduct" ]; then
            vendor=$(cat "$dev/idVendor" 2>/dev/null)
            product=$(cat "$dev/idProduct" 2>/dev/null)
            if [ "$vendor" = "$VENDOR_ID" ] && [ "$product" = "$PRODUCT_ID" ]; then
                return 0
            fi
        fi
    done
    return 1
}

# Main monitoring loop
while true; do
    if has_video_device; then
        if ! is_kvm_running; then
            echo "HDMI Capture detected - launching KVM display"
            /usr/local/bin/kvm-auto-launch-helper.sh
        fi
    fi

    sleep $CHECK_INTERVAL
done
