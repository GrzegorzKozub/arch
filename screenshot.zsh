#!/usr/bin/env zsh

set -e

# screenshot

[[ $HOST = 'drifter' ]] && RESIZE=33 || RESIZE=50

DIR=~/Pictures/Screenshots
[[ -d $DIR ]] || mkdir $DIR

fswatch --one-event --event Created $DIR | while read FILE; do
  magick $FILE -filter lanczos -resize $RESIZE% -unsharp 0x0.75 $FILE
  satty --filename $FILE >/dev/null 2>&1
  # rm $FILE
done &

# sleep 0.25

gdbus call \
  --session \
  --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  --method org.freedesktop.portal.Screenshot.Screenshot \
  '' "{'interactive':<true>}" \
  > /dev/null

# consider turning into a gnome shell extension based on
# https://github.com/OttoAllmendinger/gnome-shell-screenshot/
# https://github.com/AlexanderVanhee/Gradia
