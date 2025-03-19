#!/bin/bash

# this script should receive 1 arguments with 3 different possible values
# laptop layout :laptop
# work three monitor layout: work
# house one monitor layout: house


# only one argument and it is needed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <laptop|work|house>"
    exit 1
fi

# Default monitor setup
LAPTOP_OUTPUT="eDP1"
HOUSE_OUTPUT="DP3-3"

#  Check if house layout and usb-c 1 is connected
if xrandr | grep "DP3-3 connected"; then
    HOUSE_OUTPUT="DP3-3"
fi

#  Check if house layout and usb-c 2 is connected
if xrandr | grep "DP1-3 connected"; then
    HOUSE_OUTPUT="DP1-3"
fi

WORK_PRIMARY_OUTPUT="DP1-5"
WORK_SECONDARY_OUTPUT="DP1-6"

echo "outputs: $LAPTOP_OUTPUT $HOUSE_OUTPUT $WORK_PRIMARY_OUTPUT $WORK_SECONDARY_OUTPUT"



if [ "$XDG_CURRENT_DESKTOP" = "i3" ] || [ "$DESKTOP_SESSION" = "i3" ] || pgrep -x "i3" > /dev/null; then
    case "$1" in
        laptop)
            xrandr --output $LAPTOP_OUTPUT --primary
            xrandr --output $HOUSE_OUTPUT --off
            xrandr --output $WORK_PRIMARY_OUTPUT --off
            xrandr --output $WORK_SECONDARY_OUTPUT --off
            
            # echo "You selected laptop. Performing laptop-specific tasks..."
            # Add commands for laptop
            ;;
        work)
            xrandr --output "$WORK_PRIMARY_OUTPUT" --primary
            xrandr --output "$WORK_SECONDARY_OUTPUT" --auto --right-of "$WORK_PRIMARY_OUTPUT"
            xrandr --output "$LAPTOP_OUTPUT" --auto --left-of "$WORK_PRIMARY_OUTPUT"

            #echo "You selected work. Performing work-specific tasks..."
            # Add commands for work
            ;;
        house)
    	    xrandr --output "$HOUSE_OUTPUT" --auto 
            xrandr --output  "$LAPTOP_OUTPUT" --off
 
            echo "You selected house. Performing house-specific tasks..."
            # Add commands for house
            ;;
        *)
            echo "Invalid option. Use laptop, work, or house."
            exit 1
            ;;
    esac
else
    echo "i3 is not running. Exiting..."
fi


# Check if i3 is the running window manager
if [ "$XDG_CURRENT_DESKTOP" = "i3" ] || [ "$DESKTOP_SESSION" = "i3" ] || pgrep -x "i3" > /dev/null; then
    echo "i3 is running"
    # Set the primary, secondary, and tertiary monitors based on the detected layout
    if xrandr | grep "DP3-3 connected" || xrandr | grep "DP1-3 connected"; then
        echo "with house layout"
    	xrandr --output "$PRIMARY_OUTPUT" --auto --output  "$TERTIARY_OUTPUT" --off
    else 
        echo "work layout"
        xrandr --output "$PRIMARY_OUTPUT" --primary
        xrandr --output "$SECONDARY_OUTPUT" --auto --right-of "$PRIMARY_OUTPUT"
        xrandr --output "$TERTIARY_OUTPUT" --auto --left-of "$PRIMARY_OUTPUT"
    fi
else
    echo "i3 is not running. Exiting..."
fi

