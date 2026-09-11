# General Laptop Setup

## Z Shell

Use shell with customization, ghost text autocomplete and suggestions.

Install
```bash
sudo apt install zsh zsh-autosuggestions
```

Create config [.zshrc](/setup/.zshrc)
```bash
sudo nano ~/.zshrc
```

Enter zsh
```bash
zsh
```

Reload changes
```bash
source ~/.zshrc
```

Set as default under the **Konsole** profile

## Automatic VPN

Automatically connect to Wireguard VPN when connecting to untrusted networks.

Create script [90-wg-autotoggle](90-wg-autotoggle)
```
sudo nano /etc/NetworkManager/dispatcher.d/90-wg-autotoggle
```

Update file permissions

```
sudo chmod 755 /etc/NetworkManager/dispatcher.d/90-wg-autotoggle
sudo chown root:root /etc/NetworkManager/dispatcher.d/90-wg-autotoggle
```

Monitor issues with `journalctl -u NetworkManager -f`

## Fingerprint Unlock

Install
```bash
sudo apt install fprintd libfprint-2-2 libpam-fprintd
```

Enroll fingerprint
```bash
fprintd-enroll
```
**NOTE:** The swipe-style fingerprint sensor requires good technique to work. Swipe slowly, using the full length of the sensor, from top to bottom, with gentle pressure the whole way. See [Issue 5](../ISSUES.md) for more detail.

Register Fingerprint as a form of authentication.
```bash
sudo pam-auth-update
```
Use arrow keys to select `[] Fingerprint authentication`, press SPACE to tick `[*]`, then press ENTER to confirm

Optionally enroll other fingers
```bash
fprintd-enroll -f <finger-name>
```
Left hand:

- left-thumb
- left-index-finger
- left-middle-finger
- left-ring-finger
- left-little-finger

Right hand:

- right-thumb
- right-index-finger
- right-middle-finger
- right-ring-finger
- right-little-finger

Check what is enrolled
```bash
fprintd-list <username>
```
Test sudo unlock
```bash
sudo -k && sudo whoami
```
This should return `root`

Verify fingerprint
```bash
fprintd-verify
```
