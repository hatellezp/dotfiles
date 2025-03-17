#!/bin/bash

# Check if i3 is the running window manager
if [ "$XDG_CURRENT_DESKTOP" = "i3" ] || [ "$DESKTOP_SESSION" = "i3" ] || pgrep -x "i3" > /dev/null; then
    xrandr --output DP1-5 --primary
    xrandr --output DP1-6 --auto --right-of DP1-5
    xrandr --output eDP1 --auto --left-of DP1-5
else
    echo "i3 is not running. Exiting..."
fi
