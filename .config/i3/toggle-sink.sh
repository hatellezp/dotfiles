#!/usr/bin/env bash

# Get current default sink
current=$(pactl get-default-sink)

# Replace these with your actual sink names from `pactl list short sinks`
speakers="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
headset="bluez_output.88_C9_E8_9D_B1_35.1"

if [ "$current" = "$speakers" ]; then
    pactl set-default-sink "$headset"
else
    pactl set-default-sink "$speakers"
fi

# Move all playing streams to the new default
new_default=$(pactl get-default-sink)
for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$new_default"
done

