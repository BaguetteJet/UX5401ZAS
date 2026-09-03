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