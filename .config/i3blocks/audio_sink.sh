#!/usr/bin/env bash

# Your devices:
speakers="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
headset="bluez_output.88_C9_E8_9D_B1_35.1"

# If left-clicked (BLOCK_BUTTON=1), toggle sink
if [ "$BLOCK_BUTTON" = "1" ]; then
    # Simple inline toggle (no separate script needed)
    current=$(pactl get-default-sink)
    if [ "$current" = "$speakers" ]; then
        pactl set-default-sink "$headset"
    else
        pactl set-default-sink "$speakers"
    fi

    # Move all streams to new default
    new_default=$(pactl get-default-sink)
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$input" "$new_default"
    done
fi

# Now display current sink
sink=$(pactl get-default-sink)

if [ "$sink" = "$speakers" ]; then
    echo "蓼 Speaker"
elif [ "$sink" = "$headset" ]; then
    echo " Headset"
else
    echo "󰖁 $sink"
fi

