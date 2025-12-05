#!/usr/bin/env bash

# === CONFIG: candidate names for each physical screen ===
# Find possible candidates via: xrandr | grep " connected"
LAPTOP="eDP-1-1"   # internal laptop screen (usually stable)

# 27" monitor can appear as DP-0.6 or DP-1.5
MON27_CANDIDATES=("DP-0.6" "DP-1.6")

# 24" monitor can appear as DP-0.5 or DP-1.6
MON24_CANDIDATES=("DP-0.5" "DP-1.5")

# 42" monitor (assume stable, adjust if needed)
MON42_CANDIDATES=("DP-3")
# =====================================================

set -e

is_connected() {
    # returns 0 if output is connected
    xrandr | awk -v out="$1" '$1==out && $2=="connected"' | grep -q .
}

# Pick the first *connected* output from a list of candidates
detect_output() {
    # usage: detect_output candidate1 candidate2 ...
    for name in "$@"; do
        if is_connected "$name"; then
            echo "$name"
            return 0
        fi
    done
    return 1
}

# At runtime, resolve which actual outputs to use
MON27="$(detect_output "${MON27_CANDIDATES[@]}" || true)"
MON24="$(detect_output "${MON24_CANDIDATES[@]}" || true)"
MON42="$(detect_output "${MON42_CANDIDATES[@]}" || true)"

show_status() {
    echo "Connected outputs:"
    xrandr | awk '$2=="connected"{print " -", $1}'
    echo
    echo "Resolved logical names:"
    echo "  MON27 -> ${MON27:-<not connected>}"
    echo "  MON24 -> ${MON24:-<not connected>}"
    echo "  MON42 -> ${MON42:-<not connected>}"
}

profile_laptop_only() {
    echo "Switching to: laptop only"
    xrandr \
      --output "$LAPTOP" --auto --primary \
      ${MON27:+--output "$MON27" --off} \
      ${MON24:+--output "$MON24" --off} \
      ${MON42:+--output "$MON42" --off}
}

profile_triple() {
    # laptop (left), 27" (center, primary), 24" (right)
    echo "Switching to: laptop + 27\" + 24\""

    # Ensure we actually resolved them
    if [ -z "$MON27" ] || [ -z "$MON24" ]; then
        echo "ERROR: Could not detect 27\" or 24\" monitor."
        show_status
        exit 1
    fi

    for out in "$LAPTOP" "$MON27" "$MON24"; do
        if ! is_connected "$out"; then
            echo "ERROR: Output $out is not connected."
            show_status
            exit 1
        fi
    done

    xrandr \
      --output "$MON27" --auto --primary \
      --output "$LAPTOP" --auto --left-of "$MON27" \
      --output "$MON24" --auto --right-of "$MON27" \
      ${MON42:+--output "$MON42" --off}
}

profile_tv() {
    # laptop (left), 42" (center, primary)
    echo "Switching to: laptop + 42\""

    if [ -z "$MON42" ]; then
        echo "ERROR: Could not detect 42\" monitor."
        show_status
        exit 1
    fi

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
      ${MON27:+--output "$MON27" --off} \
      ${MON24:+--output "$MON24" --off}
}

usage() {
    cat <<EOF
Usage: $0 [laptop|triple|tv|status]

  laptop  - laptop monitor only
  triple  - laptop + 27" (center) + 24" (right)
  tv      - laptop + 42" (center)
  status  - show currently connected outputs and logical mapping
EOF
}

case "$1" in
    laptop) profile_laptop_only ;;
    triple) profile_triple ;;
    tv)     profile_tv ;;
    status) show_status ;;
    *)      usage; exit 1 ;;
esac
