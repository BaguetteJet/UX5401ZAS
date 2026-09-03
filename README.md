# Kubuntu and Windows UX5401ZAS

Dual booting Kubuntu 26.04 and Windows 11 on the Asus Zenbook 14X OLED Space Edition UX5401ZAS

## Introduction

I successfully installed Kubuntu, keeping Secure Boot on and Windows BitLocker working. I used LUKS2 encryption for the root Linux partiton and manually repaired the GRUB boot configuration after installation failure.

Why install Linux when Windows works OK? 

The short laptop battery life was the main reason to consider Linux. The Windows Subsystem for Linux 2 (WSL 2) was enough to complete my course work. I had to update the BIOS to resolve an issue where laptop took 2-3mins to power on. Since BIOS was updated, I decided to experiment with Linux.

## Contents

1. [INSTALL.md](/INSTALL.md) - Kubuntu 26.04 Installation Guide
2. [ISSUES.md](ISSUES.md) - Issues, Bugs and Fixes

## Kubuntu 26.04 Compatibility

🟢 Works by default
🔵 Works after fix
🟠 Doesn’t work TBC
🔴 Doesn’t work
🟡 Limited
⚫ Not Tested

Inputs:

- 🟢 Keyboard
- 🟢 Touchpad
- 🟢 Touchscreen
- 🟢 Stylus
- 🟢 Microphone
- 🟢 Camera
- 🟠 Fingerprint reader

Features:

- 🟠 Touchpad numberpad with backlight
- 🟢 Keyboard backlight (`Fn`+`F7`)
- 🟢 Microphone mute (`Fn`+`F9`)
- 🟠 Camera privacy shutter (`Fn`+`F10`)
- 🟢 Camera indicator LED

Ports:

- 🟢 HDMI port
- 🟢 USB-A port
- 🟢 USB-C ports charging
- ⚫ USB-C ports power output
- 🟢 USB-C ports display output
- ⚫ 3.5 mm headphone/microphone jack
- ⚫ MicroSD card reader

Wireless:

- 🟢 WiFi
- 🟢 Bluetooth

Outputs:

- 🟢 OLED Main Display 3840 × 2400 16:10 @ 60 Hz
- 🟡 OLED ZenVision external lid display (default animation, incorrect time)
- 🟡 External monitors (available resolutions incorrect HDMI, USB-C)
- 🟢 Hardware acceleration
- 🟢 Stereo speakers

Boot & Security:

- ⚫ TPM 2.0
- 🟢 Secure Boot
- 🔵 GRUB (bootloader configuration fix needed)
- 🔵 LUKS2 encryption (configuration fix needed)
- 🟢 Windows BitLocker (no recovery needed)

Behaviour:

- 🟢 Sleep/Suspend
- 🟢 Reboot
- 🟢 Shutdown
- ⚫ Hibernate
- 🟢 Battery charging
- 🟢 Brightness control
- 🟢 Lid close detection
- 🟢 Cooling fans

## Kubuntu instead of Windows

### 🟢 Pros
- Laptop runs substantially cooler
- Increased battery life
- Increased customization

### 🔴 Cons
- Installation problems
- Random bugs and issues

Unavailable Features: TBC

- No camera shutter
- No fingerprint reader
- No backpanel OLED control

## About this System

Operating System: Kubuntu 26.04 LTS   
KDE Plasma Version: 6.6.6   
KDE Frameworks Version: 6.24.0   
Qt Version: 6.10.2   
Kernel Version: 7.0.0-30-generic (64-bit)   
Graphics Platform: Wayland   
Processors: 20 × 12th Gen Intel® Core™ i9-12900H   
Memory: 32 GB of RAM (31.0 GB usable)   
Graphics Processor: Intel® Iris® Xe Graphics   
Manufacturer: ASUSTeK COMPUTER INC.   
Product Name: Zenbook UX5401ZAS_UX5401ZAS   
System Version: 1.0   