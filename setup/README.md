# General Laptop Setup

## Z Shell

## Automatic VPN

Create script [90-wg-autotoggle](90-wg-autotoggle). Update trusted networks list and vpn name.
```
sudo nano /etc/NetworkManager/dispatcher.d/90-wg-autotoggle
```

Update permissions

```
sudo chmod 755 /etc/NetworkManager/dispatcher.d/90-wg-autotoggle
sudo chown root:root /etc/NetworkManager/dispatcher.d/90-wg-autotoggle
```

Monitor issues with `journalctl -u NetworkManager -f`