#!/bin/bash

# deb-usb-wifi: A tool for configuring USB WiFi adapters on Debian-based systems
# This script changes the USB WiFi network interface name and obtains an IP address via DHCP

set -e

# Default values
NEW_IF_NAME="wlan0"

# Function to display usage
usage() {
    echo "Usage: deb-usb-wifi -i <WLAN_IF> -c <WIFI_CONF> [-n <NEW_IF_NAME>] [-h]"
    echo "  -i  Original interface name (required)"
    echo "  -c  WiFi configuration file name (required)"
    echo "  -n  New interface name (optional, default: wlan0)"
    echo "  -h  Display this help message"
    echo "Example: deb-usb-wifi -i wlx3476c5f6ca43 -c ap1 -n mywifi0"
}

# Parse command-line options
while getopts ":i:c:n:h" opt; do
    case ${opt} in
        i )
            WLAN_IF=$OPTARG
            ;;
        c )
            WIFI_CONF=$OPTARG
            ;;
        n )
            NEW_IF_NAME=$OPTARG
            ;;
        h )
            usage
            exit 0
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            exit 1
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check for required arguments
if [ -z "${WLAN_IF}" ] || [ -z "${WIFI_CONF}" ]; then
    echo "Error: Missing required options" 1>&2
    usage
    exit 1
fi

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run with root privileges" >&2
   exit 1
fi

# Check if interface exists
if ! ip link show "$WLAN_IF" &> /dev/null; then
    echo "Error: Interface $WLAN_IF not found" >&2
    exit 1
fi

# Check if configuration file exists
if [ ! -f "/etc/network/interfaces.d/$WIFI_CONF" ]; then
    echo "Warning: Configuration file /etc/network/interfaces.d/$WIFI_CONF not found"
    echo "Continuing, but DHCP configuration may fail"
fi

echo "Configuring interface $WLAN_IF..."

# Change interface name and configure
ip link set "$WLAN_IF" down
ip link set "$WLAN_IF" name "$NEW_IF_NAME"
ip link set "$NEW_IF_NAME" up

echo "Obtaining IP address using DHCP..."

# Configure DHCP
if ifup "$NEW_IF_NAME"="$WIFI_CONF"; then
    echo "Configuration complete"
    ip addr show "$NEW_IF_NAME"
else
    echo "DHCP configuration failed" >&2
    exit 1
fi
