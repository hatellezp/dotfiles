#!/bin/bash

VPN_NAME="multitel-tellez"

# Check current status
STATUS=$(nmcli connection show --active | grep "$VPN_NAME")

if [ -n "$STATUS" ]; then
    nmcli connection down id "$VPN_NAME"
    notify-send "VPN" "🔌 Disconnected from $VPN_NAME"
else
    nmcli connection up id "$VPN_NAME" && \
    notify-send "VPN" "🔒 Connected to $VPN_NAME" || \
    notify-send "VPN" "❌ Failed to connect to $VPN_NAME"
fi

