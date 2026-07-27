#!/usr/bin/env bash
set -eo pipefail -ux

if [[ ${XDG_CURRENT_DESKTOP:-} == 'GNOME' ]]; then

  gsettings set org.gnome.desktop.notifications show-banners false

  gdbus monitor -y -d org.freedesktop.login1 |
    grep --line-buffered -i "{'LockedHint': <false>}" |
    while read -r; do
      gsettings set org.gnome.desktop.notifications show-banners false
    done

fi
