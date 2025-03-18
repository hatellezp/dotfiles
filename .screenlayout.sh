#!/bin/bash

# Default monitor setup
PRIMARY_OUTPUT="DP1-5"
SECONDARY_OUTPUT="DP1-6"
TERTIARY_OUTPUT="eDP1"



#  Check if house layout and usb-c 1 is connected
if xrandr | grep "DP3-3 connected"; then
    PRIMARY_OUTPUT="DP3-3"
fi

#  Check if house layout and usb-c 2 is connected
if xrandr | grep "DP1-3 connected"; then
    PRIMARY_OUTPUT="DP1-3"
fi




# Check if i3 is the running window manager
if [ "$XDG_CURRENT_DESKTOP" = "i3" ] || [ "$DESKTOP_SESSION" = "i3" ] || pgrep -x "i3" > /dev/null; then
    # Set the primary, secondary, and tertiary monitors based on the detected layout
    if xrandr | grep "DP3-3 connected" || xrandr | grep "DP1-3 connected"; then
    	xrandr --output "$PRIMARY_OUTPUT" --auto --output  "$TERTIARY_OUTPUT" --off
    else 
        xrandr --output "$PRIMARY_OUTPUT" --primary
        xrandr --output "$SECONDARY_OUTPUT" --auto --right-of "$PRIMARY_OUTPUT"
        xrandr --output "$TERTIARY_OUTPUT" --auto --left-of "$PRIMARY_OUTPUT"
    fi
else
    echo "i3 is not running. Exiting..."
fi
