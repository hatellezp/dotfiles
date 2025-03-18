#!/bin/bash

rsync  --progress --stats --recursive --exclude=Downloads  --exclude="Langs/rust/*/*/target" --exclude="Documents/Gitlab/exllamav2" --exclude="ARIAC/TSW24-projet2-da-fer/data" --exclude=.local --exclude=.revealjs  --exclude=.npm --exclude=.modular --exclude=.docker --exclude=__pycache__ --exclude=.config --exclude=.cache --exclude=.gnupg --exclude=.dbus --archive tellez@backup-ai.ads.multitel.be:/home/tellez/backup/tellez/ /home/tellez 2> /tmp/backup.log && { zenity --info --text='Backup done'; } || zenity --error --text='Backup failed, see /tmp/backup.log'

