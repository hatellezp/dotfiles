#!/usr/bin/env bash
set -euo pipefail

TITLE="Thunderbolt Dock Diagnostic (Pop!_OS 24 + Dell WD19TB)"
KMIN_REC="6.9"   # recommended minimum kernel for ICM handshake fixes

bold() { printf "\e[1m%s\e[0m\n" "$*"; }
info() { printf "  - %s\n" "$*"; }
warn() { printf "\e[33m! %s\e[0m\n" "$*"; }
err()  { printf "\e[31m✗ %s\e[0m\n" "$*"; }
ok()   { printf "\e[32m✓ %s\e[0m\n" "$*"; }

RESET_MODULE=false
COLLECT_LOGS=false

usage() {
  cat <<EOF
$TITLE

Usage: $0 [--reset-module] [--collect-logs]

Options:
  --reset-module   Attempt a safe thunderbolt driver reset (modprobe -r/+)
  --collect-logs   Save a support bundle under ./tbt-diag-YYYYmmdd-HHMMSS.tar.gz

Notes:
  - No system changes are made unless you pass --reset-module.
  - For the WD19TB ICM handshake error (-110), kernel >= $KMIN_REC is recommended.
EOF
}

# ---------- Parse args ----------
for arg in "${@:-}"; do
  case "$arg" in
    --reset-module) RESET_MODULE=true ;;
    --collect-logs) COLLECT_LOGS=true ;;
    -h|--help) usage; exit 0 ;;
    *) err "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

bold "$TITLE"
echo

# ---------- Section: basics ----------
bold "System basics"
KVER="$(uname -r || true)"
info "Kernel: $KVER"
IDLIKE=""; . /etc/os-release 2>/dev/null || true
info "OS: ${PRETTY_NAME:-unknown}"

# Compare kernel versions (rough)
verlt() { [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]; }
if verlt "$KVER" "$KMIN_REC"; then
  warn "Kernel <$KMIN_REC detected. Known ICM fixes landed around $KMIN_REC+."
  info "Recommended (Pop!_OS): sudo apt install linux-image-oem-24.04 && sudo reboot"
else
  ok "Kernel is >= $KMIN_REC (good for ICM fixes)."
fi

# Secure Boot state (affects DKMS)
if command -v mokutil >/dev/null 2>&1; then
  SBSTATE="$(mokutil --sb-state 2>/dev/null || true)"
  info "Secure Boot: ${SBSTATE:-unknown}"
fi

# IOMMU settings
CMDLINE="$(cat /proc/cmdline 2>/dev/null || true)"
info "Kernel cmdline: $CMDLINE"
if [[ "$CMDLINE" == *"intel_iommu=off"* ]]; then
  warn "intel_iommu=off detected (can help as a workaround but reduces IOMMU features)."
  info "For finer control: try 'intel_iommu=on iommu=soft' instead of global off."
fi

echo
# ---------- Section: controller & bolt ----------
bold "Thunderbolt controller / bolt status"
if ! lsmod | grep -q '^thunderbolt'; then
  warn "thunderbolt module not currently loaded."
fi

if command -v boltctl >/dev/null 2>&1; then
  ok "boltctl found."
else
  warn "boltctl not installed. You can install it:"
  info "sudo apt update && sudo apt install bolt"
fi

# lspci controller
if command -v lspci >/dev/null 2>&1; then
  info "Thunderbolt/USB4 controllers (lspci):"
  lspci | grep -Ei 'thunderbolt|usb4|JHL|Titan Ridge|Ice Lake|Maple Ridge' || info "  (none matched)"
fi

# boltctl list
if command -v boltctl >/dev/null 2>&1; then
  echo
  info "boltctl list:"
  boltctl list || true
fi

echo
# ---------- Section: dmesg scan ----------
bold "Kernel messages (dmesg) – thunderbolt highlights"
DM="$(dmesg 2>/dev/null || true)"
echo "$DM" | grep -Ei 'thunderbolt|icm|tbt' | tail -n 80 || info "No thunderbolt entries in the last dmesg chunk."

# Common failure heuristics
echo
if echo "$DM" | grep -Eq 'failed to send driver ready to ICM|probe .* failed .* -110'; then
  warn "Detected ICM handshake / probe failure (-110)."
  info "This matches the WD19TB issue; upgrading to kernel >= $KMIN_REC is the #1 fix."
fi

# ---------- Section: peripherals ----------
echo
bold "Peripherals behind the dock (USB/Ethernet/Display)"

# USB topology
if command -v lsusb >/dev/null 2>&1; then
  info "USB devices (lsusb, top 10 lines):"
  lsusb | head -n 10
fi

# Network
if command -v nmcli >/dev/null 2>&1; then
  info "Network devices (nmcli device):"
  nmcli device || true
else
  if command -v ip >/dev/null 2>&1; then
    info "Network links (ip link summary):"
    ip -o link show | awk -F': ' '{print "  - "$2}' || true
  fi
fi

# Displays (wayland-friendly fallback: use kms/drm logs)
if command -v xrandr >/dev/null 2>&1; then
  info "Monitors (xrandr --listmonitors):"
  xrandr --listmonitors 2>/dev/null || info "  (Wayland sessions may not report via xrandr)"
fi
info "Recent DRM messages:"
echo "$DM" | grep -Ei 'drm|displayport|dp-aux' | tail -n 40 || info "  (no recent DRM lines)"

# ---------- Optional actions ----------
if $RESET_MODULE; then
  echo
  bold "Optional action: thunderbolt module reset"
  if [[ $EUID -ne 0 ]]; then
    err "Need sudo/root for module reset. Re-run: sudo $0 --reset-module"
  else
    set +e
    modprobe -r thunderbolt 2>/dev/null
    sleep 1
    modprobe thunderbolt 2>/dev/null
    set -e
    ok "thunderbolt module reloaded. Now unplug/replug the dock and re-check 'dmesg' and 'boltctl list'."
  fi
fi

# ---------- Collect logs ----------
if $COLLECT_LOGS; then
  echo
  bold "Collecting a support bundle"
  TS="$(date +%Y%m%d-%H%M%S)"
  OUT="tbt-diag-$TS"
  mkdir -p "$OUT"
  {
    echo "# $TITLE"
    echo "Kernel: $KVER"
    echo "OS: ${PRETTY_NAME:-unknown}"
    echo "Cmdline: $CMDLINE"
    echo
    echo "== lspci =="
    command -v lspci >/dev/null && lspci -nn
    echo
    echo "== lsusb =="
    command -v lsusb >/dev/null && lsusb
    echo
    echo "== nmcli =="
    command -v nmcli >/dev/null && nmcli device
    echo
    echo "== boltctl list =="
    command -v boltctl >/dev/null && boltctl list
    echo
    echo "== dmesg (filtered thunderbolt/icm) =="
    echo "$DM" | grep -Ei 'thunderbolt|icm|tbt' || true
    echo
    echo "== dmesg (drm/display) =="
    echo "$DM" | grep -Ei 'drm|displayport|dp-aux' || true
  } > "$OUT/summary.txt"

  dmesg > "$OUT/dmesg-full.txt" 2>/dev/null || true
  uname -a > "$OUT/uname.txt" || true

  tar -czf "$OUT".tar.gz "$OUT" && rm -rf "$OUT"
  ok "Bundle saved: $OUT.tar.gz"
fi

echo
bold "Next steps (most effective first)"
cat <<'EOF'
  1) If kernel < 6.9:
       sudo apt update
       sudo apt install linux-image-oem-24.04
       sudo reboot
  2) Replug the dock; then run:
       dmesg | grep -i thunderbolt
       boltctl list
  3) If still failing, try a one-time reset:
       sudo ./tbt-dock-diagnose.sh --reset-module
  4) BIOS/UEFI:
       - Enable Thunderbolt
       - Security Level: "User Authorization" or "No Security"
       - Disable pre-boot ACL / assist modes
  5) As a temporary test (not permanent):
       Edit /etc/default/grub → add to GRUB_CMDLINE_LINUX_DEFAULT:
         intel_iommu=on iommu=soft
       sudo update-grub && sudo reboot
EOF

ok "Diagnostic finished."

