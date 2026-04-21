#!/usr/bin/env bash

VPN_NAME="multitel-tellez"   # <-- same name as above

is_up() {
    nmcli -t -f NAME,TYPE connection show --active | grep -q "^${VPN_NAME}:vpn$"
}

if is_up; then
    # Line 1: full text
    echo " VPN ON"
    # Line 2: short text (used when bar is small)
    echo "VPN"
    # Line 3: color
    echo "#00ff00"
else
    echo " VPN OFF"
    echo "VPN"
    echo "#ff0000"
fi

