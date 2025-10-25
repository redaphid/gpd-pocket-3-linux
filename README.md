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

### Auto-Launch When Using as KVM (Optional)
Install event-driven auto-launch when you use the Pocket 3 as a KVM:
```bash
cd ~/Projects/pocket-3-config
sudo ./install-autolaunch.sh
```

This installs a udev rule + systemd service that triggers on EITHER:
- HDMI Capture device connects (video from server appears)
- Pocket 3 keyboard disconnects (keyboard switches to server control)
- Launches the KVM display automatically on your Pocket 3
- Event-driven via udev + systemd (no polling or background processes)
- Works regardless of which `/dev/videoX` the device gets assigned

Test by connecting the Pocket 3 to a server via the KVM module.

### How Auto-Launch Works

The auto-launch system uses a chain of services to properly launch GUI apps from hardware events:

1. **udev rule** (`99-kvm-autolaunch.rules`) - Detects hardware events (capture card connect OR keyboard disconnect)
2. **System service** (`kvm-display-auto@.service`) - Triggered by udev, runs as root
3. **Helper script** (`kvm-auto-launch-helper.sh`) - Uses `machinectl` to bridge to user session
4. **User service** (`kvm-display-user.service`) - Runs in your graphical session with proper Wayland/X11 environment
5. **Launch script** (`kvm-display.sh`) - Actually launches mpv with the capture card

This architecture properly handles Wayland sessions, XDG_RUNTIME_DIR, DBUS, and other session variables.

### Files
- `kvm-display.sh` - Main launch script
- `kvm-display.desktop` - Desktop launcher
- `kvm-display.service` - Systemd service for manual use
- `mpv-kvm.conf` - MPV configuration
- `99-kvm-autolaunch.rules` - Udev rule for device detection
- `kvm-display-auto@.service` - System service triggered by udev
- `kvm-display-user.service` - User service that runs in graphical session
- `kvm-auto-launch-helper.sh` - Helper script using machinectl
- `install-autolaunch.sh` - Installer for auto-launch

### Helpful Links
[setting up hibernate](https://abskmj.github.io/notes/posts/pop-os/enable-hibernate)
[setting up suspend-then-hibernate](https://askubuntu.com/questions/12383/how-to-go-automatically-from-suspend-into-hibernate)
[re-enable pointer on mouse move](https://raspberrypi.stackexchange.com/questions/94515/how-to-enable-the-mouse-cursor-when-only-usb-mouse-plugged-in)
Support the original creator:
- https://github.com/flexiondotorg
- https://www.patreon.com/wimpysworld
- https://streamelements.com/wimpysworld-2316/tip
