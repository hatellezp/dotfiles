#!/usr/bin/env bash

# Use dmenu or rofi as you like
CHOICE=$(printf "laptop\ntriple\ntv\n" | rofi -dmenu -p "Monitor layout:")

# If using dmenu instead of rofi, swap that line with:
# CHOICE=$(printf "laptop\ntriple\ntv\n" | dmenu -p "Monitor layout:")

[ -z "$CHOICE" ] && exit 0  # user cancelled

~/.config/i3/screenlayout.sh "$CHOICE"

