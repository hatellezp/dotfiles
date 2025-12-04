#!/usr/bin/env bash

# === CONFIG: set these to your actual output names ===
# Find them via: xrandr | grep " connected"
LAPTOP="eDP-1-1"   # internal laptop screen
MON27="DP-0.6"     # 27" monitor
MON24="DP-0.5"     # 24" monitor
MON42="DP-3"     # 42" monitor (TV, big screen)
# =====================================================

set -e

is_connected() {
    # returns 0 if output is connected
    xrandr | awk -v out="$1" '$1==out && $2=="connected"' | grep -q .
}

show_status() {
    echo "Connected outputs:"
    xrandr | awk '$2=="connected"{print " -", $1}'
}

profile_laptop_only() {
    echo "Switching to: laptop only"
    xrandr \
      --output "$LAPTOP" --auto --primary \
      --output "$MON27" --off \
      --output "$MON24" --off \
      --output "$MON42" --off
}

profile_triple() {
    # laptop (left), 27" (center, primary), 24" (right)
    echo "Switching to: laptop + 27\" + 24\""
    for out in "$LAPTOP" "$MON27" "$MON24"; do
        if ! is_connected "$out"; then
            echo "ERROR: Output $out is not connected."
            show_status
            exit 1
        fi
    done

    # Use relative placement to avoid hardcoding resolutions
    xrandr \
      --output "$MON27" --auto --primary \
      --output "$LAPTOP" --auto --left-of "$MON27" \
      --output "$MON24" --auto --right-of "$MON27" \
      --output "$MON42" --off
}

profile_tv() {
    # laptop (left), 42" (center, primary)
    echo "Switching to: laptop + 42\""
    for out in "$LAPTOP" "$MON42"; do
        if ! is_connected "$out"; then
            echo "ERROR: Output $out is not connected."
            show_status
            exit 1
        fi
    done

    xrandr \
      --output "$MON42" --auto --primary \
      --output "$LAPTOP" --auto --left-of "$MON42" \
      --output "$MON27" --off \
      --output "$MON24" --off
}

usage() {
    cat <<EOF
Usage: $0 [laptop|triple|tv|status]

  laptop  - laptop monitor only
  triple  - laptop + 27" (center) + 24" (right)
  tv      - laptop + 42" (center)
  status  - show currently connected outputs
EOF
}

case "$1" in
    laptop) profile_laptop_only ;;
    triple) profile_triple ;;
    tv)     profile_tv ;;
    status) show_status ;;
    *)      usage; exit 1 ;;
esac

