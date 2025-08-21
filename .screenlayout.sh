#!/bin/bash

# only one argument and it is needed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <laptop|work|house>"
    exit 1
fi

# names of each monitor
LAPTOP_OUTPUT="eDP1"

# Remember to adapt external monitors depending on to which usb-c port they
# are connected

if xrandr | grep "DP3-5 connected"; then
    WORK_SECONDARY_OUTPUT="DP3-5"
else
    if xrandr | grep "DP1-5 connected"; then
        WORK_SECONDARY_OUTPUT="DP1-5"
    else
        WORK_SECONDARY_OUTPUT="none"
    fi
fi

if xrandr | grep "DP3-6 connected"; then
    WORK_PRIMARY_OUTPUT="DP3-6"
else
    if xrandr | grep "DP1-6 connected"; then
        WORK_PRIMARY_OUTPUT="DP1-6"
    else
        WORK_PRIMARY_OUTPUT="none"
    fi
fi

if xrandr | grep "DP3-3 connected"; then
    HOUSE_OUTPUT="DP3-3"
else
    if xrandr | grep "DP1-3"; then
        HOUSE_OUTPUT="DP1-3"
    else
        HOUSE_OUTPUT="none"
    fi
fi

zenity --info --text="OUTPUTS: laptop=$LAPTOP_OUTPUT house=$HOUSE_OUTPUT work_primary=$WORK_PRIMARY_OUTPUT work_secondary=$WORK_SECONDARY_OUTPUT"

if [ "$XDG_CURRENT_DESKTOP" = "i3" ] || [ "$DESKTOP_SESSION" = "i3" ] || pgrep -x "i3" > /dev/null; then
    case "$1" in
        laptop)
            xrandr --output $LAPTOP_OUTPUT --primary
            xrandr --output $HOUSE_OUTPUT --off
            xrandr --output $WORK_PRIMARY_OUTPUT --off
            xrandr --output $WORK_SECONDARY_OUTPUT --off
            ;;
        work)
            xrandr --output $WORK_PRIMARY_OUTPUT --primary --mode 1920x1080
            xrandr --output $LAPTOP_OUTPUT --mode 1920x1200 --left-of $WORK_PRIMARY_OUTPUT
            xrandr --output $WORK_SECONDARY_OUTPUT --mode 1920x1200 --right-of $WORK_PRIMARY_OUTPUT
            ;;
        house)
    	    xrandr --output $HOUSE_OUTPUT --primary --mode 3840x2160
            xrandr --output  $LAPTOP_OUTPUT --mode 1920x1200 --left-of $HOUSE_OUTPUT
            xrandr --output $WORK_PRIMARY_OUTPUT --off 
            xrandr --output $WORK_SECONDARY_OUTPUT --off
            ;;
        *)
            echo "Invalid option. Use laptop, work, or house."
            exit 1
            ;;
    esac
else
    echo "i3 is not running. Exiting..."
fi


