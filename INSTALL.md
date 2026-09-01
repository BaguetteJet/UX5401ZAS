# Installing Linux

Dual booting Kubuntu 26.04 and Windows 11 on the Asus Zenbook 14X OLED Space Edition (UX5401ZAS).

## Goals

- ✅ Dual boot Windows and Linux
- ✅ Avoid BitLocker Recovery every reboot
- ✅ Keep data encrypted

## Preparation 

Steps to take before installation.

- Backup important data from Windows
- Prepare BitLocker Recovery Key
- Check Secure Boot enabled in BIOS
- Find spare USB (>16GB)
- Update BIOS

## Installation Process

### STEP 1 - Create Bootable USB

Download [Kubuntu 26.04](https://cdimage.ubuntu.com/kubuntu/releases/) from official source.

Flash the `.iso` image onto USB using [Ventoy](https://github.com/ventoy/ventoy/releases) or [balenaEtcher](https://etcher.balena.io/) (*select disk format **GPT**, not MBR*)

> ⚠️ USB contents will be wiped during the flashing process!

### STEP 2 - Suspend BitLocker

Boot into Windows and run PowerShell/Terminal as administrator.

Temporarily suspend BitLocker:

```powershell
Suspend-BitLocker -MountPoint "C:" -RebootCount 0
```

Check BitLocker status:

```powershell
manage-bde -status
```


```
Percentage encrypted: 100%
Protection Status:    Protection Off
Lock Status:          Unlocked
```

Disable Fast Startup:

```powershell
powercfg /h off
```


### STEP 3 - Create Unallocated Partition

On Windows, open **Disk Management**.

Right click on `(C:)` partition and select *Shrink Volume*. Shrink by your desired amount. *(I decided to shrink by 200,000MB)*

After completion, you should see a grey *Unallocated* partition.

```
             | OS (C:)              |             |              |              | 
260 MB       | 752 GB NTFS (BitLock | 200 GB      | 979 MB       | 200 MB       |  
Healtyh (EFI | Healthy (Boot, Page  | Unallocated | Healthy (Rec | Healthy (Rec |
```

### STEP 4 - Boot Live Environment

Power off laptop and plug in flashed USB.

Power on laptop and press `Esc` repeatedly to enter boot menu.

You select your USB as the boot option. (*USB should be listed as `UEFI: <your_usb_name>`.*)

Select `Try or Install Kubuntu`.

On the next screen, select `Try Kubuntu`.

### STEP 5 - Checks

First check you booted into **UEFI** mode.

Open **Konsole** and run command:

```bash
test -d /sys/firmware/efi && echo UEFI || echo Legacy
```

> 🛑 Output should be `UEFI` and not `Legacy`. I resolved this issue here: [Issue 1](#issue-1---live-environment-legacy-instead-of-uefi)

Play around with the environment before you continue installation. Check buttons, bluetooth, sound, WiFi, display, etc.

### STEP 6 - Install OS

Click on the installation desktop icon to begin. Make sure to connect to the internet and plug in your AC power adapter.

Progess through setup until **Partitions**.

Select **Manual Patition**.

You should see something like this:

```
Name            | File System | File System Label | Mount Point | Size           
/dev/nvme0n1p1    FAT32         SYSTEM                            260 MiB
/dev/nvme0n1p2    unknown                                         16 MiB
/dev/nvme0n1p3    BitLocker                                       752 GiB
Unallocated       ext4                                            200 GiB      
/dev/nvme0n1p4    NTFS                                            979 MiB  
/dev/nvme0n1p5    FAT32         MYASUS                            200 MiB  
```

Click on the **SYSTEM** partition and select Edit. Set mount point to `/boot/efi`. Do not format. Only check the `Boot` flag (I left `bios-grub` unchecked. I didn't have an `esp` flag).

Click on the **Unallocated** partition and select Create. This will be the **BOOT** partiton. Set size to 1000 MiB, format as `ext4` and DO NOT encrypt. Set mount point as `/boot`, call partition **BOOT**, leave all flags unchecked.

Click on the **Unallocated** partition and select Create. This will be the root **KUBUNTU** partition. Set size to remaining space, format as `ext4` (NOT LUKS2) and select encrypt. Choose a passphrase for unlocking the partition. Call the partition **KUBUNTU** and leave all flags unchecked.

**SHOULD LOOK LIKE THIS:**

```
Name            | File System | File System Label | Mount Point | Size           
/dev/nvme0n1p1    FAT32         SYSTEM              /boot/efi     260 MiB
/dev/nvme0n1p2    unknown                                         16 MiB
/dev/nvme0n1p3    BitLocker                                       752 GiB
New Partition     ext4          BOOT                /boot         1000 MiB
New Partition     LUKS2         KUBUNTU             /             199 GiB
/dev/nvme0n1p4    NTFS                                            979 MiB
/dev/nvme0n1p5    FAT32         MYASUS                            200 MiB
```

Continue.

> ⚠️ Warning pops up claiming the `/boot/efi` partition must be at least 300 MiB. This can be ignored.

Set up credentials and continue installation.

The installaion should progress until fully until the very end, where I got an error informing me the installation failed.

> 🛑 Installation Failed   
> Bootloader installation error   
> Details:   
> ```The bootloader could not be installed. The installation command <pre>grub-install --target=x86_64-efi --efi-directory=boot/efi --bootloader-id=ubuntu --force</pre> returned error code 1.```   
> X Close

I resolved this issue here: [Issue 2](#issue-2---bootloader-could-not-be-installed)

Complete installtion and unplug USB.

### STEP 7 - Clean up

Once your Kubuntu installation is complete. Reboot and press `F2` repeatedly to enter BIOS.

Change boot order.

- Ubuntu
- Windows 

Exit and reboot. You should see the GRUB menu. Enter Windows Boot Manager to return to Windows.

Run PowerShell/Terminal as administrator.

Resume BitLocker after Kubuntu installation is complete using

```powershell
Resume-BitLocker -MountPoint "C:"
```

Reboot and begin to enjoy Kubuntu!

## Issues

These are the issues I had during the installation process. For issues after installation, see [ISSUES.md](/ISSUES.md).

### Issue 1 - Live Environment Legacy instead of UEFI

I tried multiple reboots.

Attempt 1 - Used Ventoy MBR following [About Secure Boot in UEFI mode](https://ventoy.net/en/doc_secure.html). USB showed UEFI. Ventoy showed UEFI. Live environment was `Legacy`.

Attempt 2 - Used Ventoy GPT. USB showed UEFI, Ventoy showed UEFI, but live environment was `Legacy`.

Attempt 3 - Used balenaEtcher. USB showed UEFI, Live environment took substantially longer to load, but was still `Legacy`.

Attempt 4 - Loaded into Windows first, then restarted with USB plugged in. Used balenaEtcher. USB showed UEFI, Live environment finally showed `UEFI`.

I am unsure what caused this issue.

### Issue 2 - Bootloader could not be installed

This problem took me a while to fix.

Attempt 1 - */dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **unecrypted** `/`. FAILED. I deleted the */dev/nvme0n1p6* partition to retry.

Attempt 2 - */dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **encrypted** `/`. FAILED. I tried rebooting and noticed the ubuntu boot option was available. It would bring me to a `GRUB>` termianl instead of the GRUB menu. I couldn't find any information on this installation failure online, so I attempted to fix issue with the assitance of LLMs Claude and DeepSeek. I was able to boot into live environment from the USB stick, and confirmed that GRUB was fine, and Kubuntu installed. I was able to enter the root of the Kubuntu partition. After countless hours, I came to the conclusion that GRUB couldn't access `/boot`, which was inside the encrypted patition. I was unable to rebuild brub with the needed modules to access the encrypted partition.

Attempt 3 - */dev/nvme0n1p1* -> `/boot/etc`, New partiton */dev/nvme0n1p6* `ext4` **unencrypted** `/boot` 1000 MiB, New partiton */dev/nvme0n1p7* `ext4` **encrypted** `/`. FAILED. Rebooting would bring me to a `GRUB>` termianl instead of the GRUB menu. I attempted to fix issue with the assitance of LLMs Claude and ChatGPT. Eventually ChatGPT was able to diagnose the problem and provide me with a working solution. 

Attempt 4 - 

## Versions

- BIOS version 311 [product support](https://www.asus.com/us/supportonly/ux5401zas/helpdesk_bios/)
- Kubuntu 26.04.1
- GRUB version 2.14
