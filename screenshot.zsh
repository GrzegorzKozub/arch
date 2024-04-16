#!/usr/bin/env zsh

set -e

# screenshot

# flameshot gui

FILE=/tmp/screenshot.png
gnome-screenshot --area --file $FILE
satty --filename $FILE
rm $FILE

