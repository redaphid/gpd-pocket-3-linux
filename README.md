This repository is a modified and stripped down version of: https://github.com/wimpysworld/umpc-ubuntu

## KVM Module Display

Launch the KVM module display by pressing Super and typing "kvm", or run:
```bash
~/Projects/pocket-3-config/kvm-display.sh
```

### Features
- Auto-detects HDMI Capture device
- Fullscreen by default
- Ultra-low latency (~50ms)
- 1920x1080 @ 60fps

### Auto-Launch on Connection (Optional)
Install event-driven auto-launch when HDMI cable is plugged in:
```bash
cd ~/Projects/pocket-3-config
sudo ./install-autolaunch.sh
```

This installs a udev rule + systemd service that:
- Triggers instantly when HDMI Capture device (USB 3188:1000) is detected
- Launches the KVM display automatically
- Event-driven (no polling or background processes)
- Works regardless of which `/dev/videoX` the device gets assigned

Test by unplugging and replugging the HDMI cable to the KVM module.

### Files
- `kvm-display.sh` - Main launch script
- `kvm-display.desktop` - Desktop launcher
- `kvm-display.service` - Systemd service for manual use
- `mpv-kvm.conf` - MPV configuration
- `99-kvm-autolaunch.rules` - Udev rule for device detection
- `kvm-display-auto@.service` - Systemd service triggered by udev
- `kvm-auto-launch-helper.sh` - Helper script for launching
- `install-autolaunch.sh` - Installer for auto-launch

### Helpful Links
[setting up hibernate](https://abskmj.github.io/notes/posts/pop-os/enable-hibernate)
[setting up suspend-then-hibernate](https://askubuntu.com/questions/12383/how-to-go-automatically-from-suspend-into-hibernate)
[re-enable pointer on mouse move](https://raspberrypi.stackexchange.com/questions/94515/how-to-enable-the-mouse-cursor-when-only-usb-mouse-plugged-in)
Support the original creator:
- https://github.com/flexiondotorg
- https://www.patreon.com/wimpysworld
- https://streamelements.com/wimpysworld-2316/tip
