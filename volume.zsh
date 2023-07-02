#!/usr/bin/env zsh

set -e

if [[ $1 = 'down' ]]; then

  pactl set-sink-volume @DEFAULT_SINK@ -5%

elif [[ $1 = 'up' ]]; then

  [ $(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\{1,3\}%' | head -n 1 | sed 's/%//') -lt 100 ] \
    && pactl set-sink-volume @DEFAULT_SINK@ +5%

else

  pactl set-sink-mute @DEFAULT_SINK@ toggle

fi

