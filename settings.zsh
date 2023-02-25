#!/usr/bin/env zsh

set -e -o verbose

# sound

pactl set-sink-volume @DEFAULT_SINK@ 50%
pactl set-source-volume @DEFAULT_SOURCE@ 50%

[[ $HOST = 'drifter' ]] && pactl set-sink-mute @DEFAULT_SINK@ 1

# network

if [[ $HOST = 'player' ]]; then
  nmcli radio wifi off
  rfkill block bluetooth
fi

# power

if [[ $HOST = 'drifter' ]]; then
  powerprofilesctl set power-saver
else
  powerprofilesctl set balanced
fi

