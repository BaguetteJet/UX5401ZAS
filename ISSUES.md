# Issues After Installation
Here is a list of issues I encountered after installation.


## Try Kubuntu or Install Kubuntu screen

## 1. Camera privacy shutter not working
**PENDING**

## 2. Fingerprint scanner not working
**PENDING**

## 3. Laptop stylus battery status
**PENDING**

The laptop came with an Asus stylus. The stylus works fine with the display, but shows in the UI under the battery section as **ELAN9008:00 04F3:4065 Stylus**. Only shows no battery or charging 1%.

## 4. External display scaling incorrect
**PENDING**

## 5. Sound broke working after connecting external display
**RESOLVED** ~2hrs

Connecting external monitor through HDMI -> USB C adapter caused the audio to malfunction. The speaker audio would play for a ~1s before cutting out. The issue persisted across restarts. Audio worked fine when booting into Windows 11 or using headphones. Tried resolving issue with different drivers, previous kernel versions and various config settings.

The embedded controller (EC), the low-level chip that manages hardware routing, power states, and physical connectors independently of the OS got stuck in a bad state. A normal reboot doesn't reset the EC, only a full power drain does.

**FIX**   
Shutdown laptop fully (not restart) and hold power button down for 15-20s before powering on.

