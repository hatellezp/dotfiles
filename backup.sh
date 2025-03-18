#!/bin/bash

rsync --delete --progress --stats --recursive --exclude=Downloads  --exclude="Langs/rust/*/*/target" --exclude="Documents/Gitlab/exllamav2" --exclude="ARIAC/TSW24-projet2-da-fer/data" --exclude=.local --exclude=.revealjs  --exclude=.npm --exclude=.modular --exclude=.docker --exclude=__pycache__ --exclude=.config --exclude=.cache --exclude=.gnupg --exclude=.dbus --archive /home/tellez tellez@backup-ai.ads.multitel.be:/home/tellez/backup 2> /tmp/backup.log && { zenity --info --text='Backup done'; } || zenity --error --text='Backup failed, see /tmp/backup.log'

