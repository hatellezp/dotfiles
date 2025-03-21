#!/bin/bash

chosen=$(echo -e "f) Firefox\np) Private Firefox\nz) Zotero\ng) Chrome\nc) VS Code\no) Obsidian" | dmenu -i -p "Launch:" | cut -d')' -f1)

case "$chosen" in
    f) exec org.mozilla.firefox ;;
    p) exec firefox -private ;;
    z) exec org.zotero.Zotero ;;
    g) exec com.google.Chrome --disable-gpu ;;
    c) exec code --disable-gpu ;;
    o) exec md.obsidian.Obsidian --disable-gpu ;;
esac

