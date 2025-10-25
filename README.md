# GPD Pocket 3 Linux Configuration

Lightweight, optimized KVM module display for GPD Pocket 3 running Pop!_OS/Linux.

## Hardware
- **Device**: GPD Pocket 3 with KVM Module
- **KVM Capture Card**: Auto-detected (typically `/dev/video2`)
  - Hardware ID: XF HDMI Capture (Vendor: 3188, Model: 1000)
  - Resolution: 1920x1080 @ 60fps
- **Built-in Camera**: `/dev/video0` (1600x1200 @ 30fps)

## Features
- **Auto-detection**: Automatically finds the HDMI Capture device
- **Fullscreen by default**: Launches in fullscreen mode
- **Ultra-low latency**: ~50ms delay, optimized for live video
- **Hardware acceleration**: GPU-accelerated decoding
- **Reliable**: Falls back to `/dev/video2` if detection fails
- **Quick launch**: Type "kvm" in GNOME search to launch

## Installation

```bash
# Clone the repository
git clone <repo-url> ~/Projects/gpd-pocket-3-linux
cd ~/Projects/gpd-pocket-3-linux

# Make script executable
chmod +x kvm-display.sh

# Install desktop entry
cp kvm-display.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/

# Optional: Install MPV config
cp mpv-kvm.conf ~/.config/mpv/kvm.conf

# Optional: Install systemd service for auto-start
cp kvm-display.service ~/.config/systemd/user/
systemctl --user enable kvm-display.service
```

## Quick Start

### Launch KVM Display

**Option 1**: Press Super key and type "kvm", then press Enter

**Option 2**: Run from terminal:
```bash
~/Projects/gpd-pocket-3-linux/kvm-display.sh
```

The script will:
1. Automatically detect your HDMI Capture device
2. Launch in fullscreen mode
3. Display server video with minimal latency

### Manual Command
```bash
mpv /dev/video2 --profile=low-latency --untimed --fullscreen
```

## Controls (when mpv window is focused)
- `q` or `ESC` - Quit
- `f` - Toggle fullscreen
- `m` - Mute/unmute audio

## Repository Files

1. **`kvm-display.sh`** - Launch script with auto-detection and optimized settings
2. **`mpv-kvm.conf`** - MPV configuration for ultra-low latency KVM capture
3. **`kvm-display.desktop`** - Application launcher (install to `~/.local/share/applications/`)
4. **`kvm-display.service`** - Systemd service for auto-start (install to `~/.config/systemd/user/`)
5. **`README.md`** - This file

## Advanced Options

### Auto-start on Boot

```bash
# Copy service file
cp kvm-display.service ~/.config/systemd/user/

# Enable and start
systemctl --user enable kvm-display.service
systemctl --user start kvm-display.service
```

### Alternative Players

**FFplay (lighter, but basic):**
```bash
ffplay -f v4l2 -i /dev/video2 -fflags nobuffer -flags low_delay -framedrop
```

**VLC:**
```bash
vlc v4l2:///dev/video2:v4l2-standard= :live-caching=0
```

## Troubleshooting

### Auto-detection fails
If the script can't find the HDMI Capture device:
```bash
# List all video devices with details
for dev in /dev/video*; do echo "=== $dev ==="; udevadm info --name="$dev" | grep -E "ID_MODEL|ID_V4L_PRODUCT"; done
```
- Look for "HDMI Capture" in the output
- The script falls back to `/dev/video2` automatically
- If your capture card is on a different device, edit the fallback in `kvm-display.sh`

### No video signal
- Ensure HDMI cable is connected to KVM module's HDMI IN port
- Check server is outputting video
- Try: `ls -la /dev/video*` to verify devices
- Run script manually to see detection output: `./kvm-display.sh`

### Corrupted frames warning
- Normal for first few frames on startup
- If persistent, server may be outputting incompatible resolution
- Try different resolution on server (1920x1080, 1280x720, 1024x768)

### High CPU usage
- mpv is already optimized with hardware acceleration (`hwdec=auto`)
- Check: `mpv /dev/video2 --hwdec=vaapi` for Intel GPU acceleration
- Monitor: `htop` to see CPU usage

### Audio not working
- KVM module captures video only (no audio over HDMI)
- Use separate audio connection if needed

## Performance Notes
- Current setup uses minimal CPU (< 10% on Intel Iris Xe)
- 60fps capture with ~50ms latency
- Hardware decoding enabled for YUYV422 format
