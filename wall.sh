#!/usr/bin/env bash

set -e

if [[ $XDG_CURRENT_DESKTOP == 'GNOME' ]]; then

  FILE="file://$XDG_DATA_HOME/backgrounds/$(~/code/walls/random.sh)"

  gsettings set org.gnome.desktop.background picture-uri "$FILE"
  gsettings set org.gnome.desktop.background picture-uri-dark "$FILE"

  gsettings set org.gnome.desktop.screensaver picture-uri "$FILE"

fi
