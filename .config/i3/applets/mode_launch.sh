#!/bin/bash

# Define menu options with one-letter shortcuts
options="f Firefox\np Private Firefox\nz Zotero\ng Chrome\nc VS Code\no Obsidian"

# normal
# regex
# glob
# fuzzy
# prefix


# Show the menu with `rofi`, allowing selection with a single keypress
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Launch:" -matching regex " ") #  -no-custom -select " ")

# Extract only the first letter (shortcut key)
key=$(echo "$chosen" | awk '{print $1}')

# Match the key and launch the corresponding application
case "$key" in
    f) exec org.mozilla.firefox ;;
    p) exec firefox -private ;;
    z) exec org.zotero.Zotero ;;
    g) exec com.google.Chrome --disable-gpu ;;
    c) exec code --disable-gpu ;;
    o) exec md.obsidian.Obsidian --disable-gpu ;;
    *) notify-send "Invalid selection: $chosen" ;;  # Handle unexpected input
esac

