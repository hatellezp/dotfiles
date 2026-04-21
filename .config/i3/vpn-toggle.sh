#!/usr/bin/env bash

VPN_NAME="multitel-tellez"   # <-- change this to your VPN connection name

# Check if VPN is currently active
if nmcli -t -f NAME,TYPE connection show --active | grep -q "^${VPN_NAME}:vpn$"; then
    # It's up -> bring it down
    nmcli connection down "$VPN_NAME"
else
    # It's down -> bring it up
    nmcli connection up "$VPN_NAME"
fi

