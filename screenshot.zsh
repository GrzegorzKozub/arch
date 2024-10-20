#!/usr/bin/env zsh

set -e

# screenshot

[[ $HOST = 'drifter' ]] && RESIZE=33 || RESIZE=50

FILE=/tmp/screenshot.png
gnome-screenshot --area --file $FILE
magick $FILE -filter lanczos -resize $RESIZE% -unsharp 0x0.75 $FILE
satty --filename $FILE
rm $FILE

