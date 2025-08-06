#!/usr/bin/env zsh

set -e

# screenshot

[[ $HOST = 'drifter' ]] && RESIZE=33 || RESIZE=50
[[ $1 = 'delay' ]] && DELAY=3 || DELAY=0

FILE=/tmp/screenshot.png
gnome-screenshot --area --file $FILE --delay $DELAY
magick $FILE -filter lanczos -resize $RESIZE% -unsharp 0x0.75 $FILE
satty --filename $FILE
rm $FILE

