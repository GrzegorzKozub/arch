#!/usr/bin/env zsh

set -e

# screenshot

FILE=/tmp/screenshot.png
FILE2=/tmp/screenshot2.png
gnome-screenshot --area --file $FILE
magick $FILE -resize 50% $FILE2
satty --filename $FILE2
rm $FILE
rm $FILE2

