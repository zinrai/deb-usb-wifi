# deb-usb-wifi

`deb-usb-wifi` is a command-line tool designed for Debian-based systems to simplify the configuration of USB WiFi adapters. It automates the process of changing the network interface name and obtaining an IP address via DHCP.

## Features

- Renames USB WiFi network interfaces
- Configures the interface using a specified configuration file
- Obtains an IP address via DHCP
- Provides clear error messages and warnings

## Prerequisites

- A Debian-based system (e.g., Debian, Ubuntu)
- Root privileges
- `ip` and `ifup` commands (typically pre-installed on Debian systems)

## Usage

The basic syntax for using `deb-usb-wifi` is:

```
$ sudo deb-usb-wifi.sh -i <WLAN_IF> -c <WIFI_CONF> [-n <NEW_IF_NAME>]
```

Example:
```
$ sudo deb-usb-wifi -i wlx3476c5f6ca43 -c ap1 -n mywifi0
```

## Configuration File

The WiFi configuration file should be located in `/etc/network/interfaces.d/` and contain the necessary settings for your WiFi connection. For example:

```
iface ap1 inet dhcp
    wpa-conf /etc/wpa_supplicant/ap1.conf
```

## Troubleshooting

1. If you encounter a "Permission denied" error, make sure you're running the script with `sudo`.

2. If the script fails to find your WiFi interface, check that your USB WiFi adapter is properly connected and recognized by your system. You can list available network interfaces using:
   ```
   ip link show
   ```

3. If DHCP configuration fails, ensure that your WiFi configuration file is correctly set up and that you're within range of the specified WiFi network.

## License

This project is licensed under the MIT License - see the [LICENSE](https://opensource.org/license/mit) for details.
