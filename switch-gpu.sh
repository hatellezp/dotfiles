#!/usr/bin/env bash
# switch-gpu.sh — safely switch GPU modes on Pop!_OS Cosmic
# Usage: sudo ./switch-gpu.sh [intel|nvidia|hybrid|status]

set -e

show_help() {
    cat << EOF
Usage: sudo $(basename "$0") [intel|nvidia|hybrid|status]

Switch GPU mode on Pop!_OS:
  intel     → Use Intel integrated graphics only (power-saving mode)
  nvidia    → Use NVIDIA dedicated GPU only (performance mode)
  hybrid    → Use hybrid graphics (Intel display, NVIDIA offload)
  status    → Show current GPU mode

Example:
  sudo $(basename "$0") intel
EOF
}

# Require root privileges
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run this script with sudo."
    exit 1
fi

# Argument check
if [[ $# -ne 1 ]]; then
    show_help
    exit 1
fi

INPUT="$1"
case "$INPUT" in
    intel)
        MODE="integrated"
        DESC="Use Intel integrated graphics only (power-saving)"
        ;;
    nvidia)
        MODE="nvidia"
        DESC="Use NVIDIA dedicated GPU only (performance)"
        ;;
    hybrid)
        MODE="hybrid"
        DESC="Use hybrid graphics (Intel display, NVIDIA offload)"
        ;;
    status)
        echo "🔍 Checking current GPU mode..."
        CURRENT_MODE=$(system76-power graphics 2>/dev/null || echo "unknown")
        echo "✅ Current GPU mode: $CURRENT_MODE"
        exit 0
        ;;
    -h|--help|help)
        show_help
        exit 0
        ;;
    *)
        echo "❌ Invalid option: $INPUT"
        show_help
        exit 1
        ;;
esac

# Detect current mode
CURRENT_MODE=$(system76-power graphics 2>/dev/null || echo "unknown")
echo "🔍 Current GPU mode: $CURRENT_MODE"

# Confirm with user
echo "⚙️  You are about to switch GPU mode to: $INPUT ($DESC)"
read -rp "Are you sure you want to continue? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❎ Operation cancelled."
    exit 0
fi

# Apply mode
echo "🔧 Applying GPU mode: $MODE ..."
system76-power graphics "$MODE"

echo "✅ GPU mode set to '$MODE'."
read -rp "Reboot now to apply changes? (y/N): " REBOOT
if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
    echo "🔁 Rebooting..."
    reboot
else
    echo "⚠️  Remember to reboot later for changes to take effect."
fi

