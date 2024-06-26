#!/usr/bin/env zsh

set -e

# screenshot

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  FILE=/tmp/screenshot.png
  gnome-screenshot --area --file $FILE
  satty --filename $FILE
  rm $FILE

else

  flameshot gui

fi

