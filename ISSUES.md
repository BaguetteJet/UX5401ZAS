# Issues
Here is a list of issues I encountered with Kubuntu.

Also see bugs I encountered here: [Bugs](#bugs)

| # | Issue | Status |
| --- | --- | --- |
| 1 | [Live Environment Legacy instead of UEFI](#issue-1---live-environment-legacy-instead-of-uefi) | Resolved |
| 2 | [Bootloader could not be installed](#issue-2---bootloader-could-not-be-installed) | Resolved |
| 3 | [Try Kubuntu or Install Kubuntu screen](#issue-3---try-kubuntu-or-install-kubuntu-screen) | Resolved |
| 4 | [Camera privacy shutter not working](#issue-4---camera-privacy-shutter-not-working) | Pending |
| 5 | [Fingerprint scanner not working](#issue-5---fingerprint-scanner-not-working) | Pending |
| 6 | [Laptop stylus battery status](#issue-6---laptop-stylus-battery-status) | Pending |
| 7 | [External display scaling incorrect](#issue-7---external-display-scaling-incorrect) | Pending |
| 8 | [Sound broke working after external display](#issue-8---sound-broke-working-after-connecting-external-display) | Resolved |
| 9 | [CD-ROM repo entry listed in APT sources](#issue-9---cd-rom-repo-entry-listed-in-apt-sources) | Resolved |

## Issue 1 - Live Environment Legacy instead of UEFI
**RESOLVED** ~2hrs

BIOS and ISO/USB were set up correct. I tried multiple reboots. During installation. the live environment kept booting into Legacy instead of UEFI mode.

To check, in **Konsole** run command:

```bash
test -d /sys/firmware/efi && echo UEFI || echo Legacy
```

Attempt 1 - Used Ventoy MBR USB showed UEFI. Ventoy showed UEFI. Live environment was `Legacy`.

Attempt 2 - Used Ventoy GPT. USB showed UEFI, Ventoy showed UEFI, but live environment was `Legacy`.

Attempt 3 - Used balenaEtcher. USB showed UEFI, Live environment took substantially longer to load, but was still `Legacy`.

Attempt 4 - Loaded into Windows first, then restarted with USB plugged in. Used balenaEtcher. USB showed UEFI, Live environment finally showed `UEFI`.

**FIX**   
It fixed itself after I went to eat dinner and booted into Windows once. 

## Issue 2 - Bootloader could not be installed
**RESOLVED** ~8hrs

The installation kept failing with the error:

> 🛑 Installation Failed   
> Bootloader installation error   
> Details:   
> ```The bootloader could not be installed. The installation command <pre>grub-install --target=x86_64-efi --efi-directory=boot/efi --bootloader-id=ubuntu --force</pre> returned error code 1.```   
> X Close

Rebooting and pression `Esc` showed Ubuntu boot option was available. It led to a GRUB> terminal instead of the GRUB menu. 

Attempt 1 - INSTALLATION FAILED  
*/dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **unecrypted** `/`. I deleted the */dev/nvme0n1p6* partition to retry.

Attempt 2 - INSTALLATION FAILED   
*/dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **encrypted** `/`. I was able to boot into live environment from the USB stick, and confirm that both GRUB and Kubuntu installed successfully. I discovered GRUB was unable to access `/boot` inside the encrypted partition. I was unable to rebuild GRUB with the modules required as Ubuntu used a signed version of GRUB and a signed shim to work with Secure Boot.

Attempt 3 - INSTALLATION FAILED + FIX   
*/dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **unencrypted** `/`. Now that `/boot` was not encrypted, I was able to repair the GRUB boot configuration/installation. I had a working, bootable OS but I was not satisfied as the root was not encrypted. [logs](/logs/install-issue2-attempt3-unencrypted.log)

Attempt 4 - INSTALLATION FAILED + FIX   
*/dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **unencrypted** `/boot` 1000 MiB, New partiton */dev/nvme0n1p7* `ext4` **encrypted** `/`. Learning from the previous attempt, creating a separate unencrypted boot partition, I was able to successfully repair the GRUB boot configuration/installation and had working, bootable, encrypted OS. [logs](/logs/install-issue2-attempt4-encrypted.log)

Two main issues:

1. `grub.cfg` was missing entirely
2. `crypttab/mapper` name mismatch

**FIX**

Boot a Kubuntu live USB/ISO.

Unlock the LUKS2 partition.

```
sudo cryptsetup luksOpen /dev/nvme0n1p7 cryptroot
```
   
Mount root and boot partitions.

```
sudo mount /dev/mapper/cryptroot /mnt
sudo mount /dev/nvme0n1p6 /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot/efi
```

Check whether `grub.cfg` exists

```
sudo ls -lah /mnt/boot/grub/
```
If `grub.cfg` is missing, that's the root cause of the GRUB> terminal.

Bind-mount system dirs and chroot.

```
sudo mount --bind /dev /mnt/dev
sudo mount --bind /dev/pts /mnt/dev/pts
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /run /mnt/run
sudo chroot /mnt /bin/bash
```

Check `/etc/crypttab` and `/etc/fstab` - make sure the mapper name used in `crypttab` matches the name referenced in `fstab` (e.g. both should say `cryptroot`, not a long UUID-based name). Edit with `nano` if they don't match.

In `/etc/default/grub`, remove any leftover `cryptdevice=...` parameter from `GRUB_CMDLINE_LINUX_DEFAULT` - the initramfs will pick up the root device from `/etc/crypttab` instead.

Rebuild the initramfs.

```
update-initramfs -u -k 7.0.0-14-generic
```
Confirm there are no `cryptsetup: WARNING` messages.

Regenerate the GRUB config.

```
grub-mkconfig -o /boot/grub/grub.cfg
```

Reinstall the GRUB EFI bootloader.

```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu --recheck
```

Exit the chroot and unmount everything.

```
exit
sudo umount -R /mnt
```

Reboot and remove the live USB.


## Issue 3 - Try Kubuntu or Install Kubuntu screen
**RESOLVED** ~15mins

Booting into Kubuntu would greet me with a Try Kubuntu or Install Kubuntu screen.

**FIX**   
From login screen, change environment to `wayland` in the bottom left.

## Issue 4 - Camera privacy shutter not working
**PENDING**

`Fn` + `F10` does not operate the camera shutter.

## Issue 5 - Fingerprint scanner not working
**PENDING**

Fingerprint scanner not detected.

## Issue 6 - Laptop stylus battery status
**PENDING**

The laptop came with an Asus stylus. The stylus works fine with the display, but shows in the UI under the battery section as ELAN9008:00 04F3:4065 Stylus. Only shows as no battery or charging 1%.

## Issue 7 - External display scaling incorrect
**PENDING**

Dell ultra wide monitor native 3440 x 1440 (21:9) @ 144Hz. Connecting directly via HDMI results in a max available 2560 x 1440 (16:9) @ 59.98Hz. Using a HDMI -> USB C adapter results in max available 3440 x 1440 (21:9) @ 99.98Hz.


## Issue 8 - Sound broke working after connecting external display
**RESOLVED** ~2hrs

Connecting external monitor through HDMI -> USB C adapter caused the audio to malfunction. The speaker audio would play for a ~1 sec before cutting out. The issue persisted across restarts. Audio worked fine when booting into Windows 11 or using headphones. Tried resolving issue with different drivers, previous kernel versions and various config settings.

I believe the embedded controller (EC), the low-level chip that manages hardware routing, power states, and physical connectors independently of the OS got stuck in a bad state. A normal reboot doesn't reset the EC, only a full power drain does.

**FIX**   
Shutdown laptop fully (not restart) and hold power button down for 15-20s before powering on.

## Issue 9 - CD-ROM repo entry listed in APT sources
**RESOLVED** ~5mins

Running `sudo apt update` resulted in error because an old CD-ROM repo entry is still listed in your APT sources.

```
igor@zenbook:~$ sudo apt update                         
Ign:1 file:/cdrom resolute InRelease
Err:2 file:/cdrom resolute Release
  File not found - /cdrom/dists/resolute/Release (2: No such file or directory)
Error: The repository 'file:/cdrom resolute Release' no longer has a Release file.
```

**FIX**    
```
sudo rm /etc/apt/sources.list.d/cdrom.sources
```

# Bugs

## Bug 1 - Freeze and max fan speed

The laptop froze and set fan speed to max after disconnecting external monitor. Eventually unfroze but fans remained at max speed. Restart did not resolve. Needed full shutdown.