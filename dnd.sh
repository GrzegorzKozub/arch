#!/bin/sh

gsettings set org.gnome.desktop.notifications show-banners false

gdbus monitor -y -d org.freedesktop.login1 | \
  grep --line-buffered -i "{'LockedHint': <false>}" | \
  while read; do
    gsettings set org.gnome.desktop.notifications show-banners false
  done

