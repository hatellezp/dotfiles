#!/usr/bin/env bash

# Simple rofi-based power menu for i3

# You can change this to use a custom theme if you have one:
# rofi_command="rofi -theme ~/.config/rofi/powermenu.rasi -dmenu -i -p"
rofi_command="rofi -dmenu -i -p"

# Options (feel free to tweak icons/text)
lock="  Lock"
logout="  Logout"
suspend="  Suspend"
reboot="  Reboot"
shutdown="  Shutdown"

# Build the menu
options="$lock\n$logout\n$suspend\n$reboot\n$shutdown"

# Show menu and get choice
chosen="$(echo -e "$options" | $rofi_command "Power")"

case "$chosen" in
    "$lock")
        # Lock the screen
        i3lock
        ;;

    "$logout")
        # Exit i3
        i3-msg exit
        ;;

    "$suspend")
        # Suspend (xss-lock will trigger i3lock if configured)
        systemctl suspend
        ;;

    "$reboot")
        # Reboot the system
        systemctl reboot
        ;;

    "$shutdown")
        # Power off the system
        systemctl poweroff
        ;;

    *)
        # Do nothing if user cancels or closes rofi
        exit 0
        ;;
esac
