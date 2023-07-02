#!/usr/bin/env zsh

set -e

mute() { pactl set-sink-mute @DEFAULT_SINK@ toggle }

down() { pactl set-sink-volume @DEFAULT_SINK@ -5% }

up() {
  [ $(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\{1,3\}%' | head -n 1 | sed 's/%//') -lt 100 ] \
    && pactl set-sink-volume @DEFAULT_SINK@ +5%
}

device() {
  [[ $1 = 'sink' ]] && local snk=true
  [[ $1 = 'source' ]] && local src=true

  [[ $snk ]] && local all=$(pactl list short sinks | cut -f2) && local default='Default Sink'
  [[ $src ]] && local all=$(pactl list short sources | cut -f2) && local default='Default Source'

  while true; do
    echo $all | while read -r current; do
      if [[ $switch ]]; then
        [[ $snk ]] && pactl set-default-sink $current
        [[ $src ]] && pactl set-default-source $current
        [[ $(pactl info | grep $default | cut -d' ' -f3) = $current ]] && return
      fi
      [[ $(pactl info | grep $default | cut -d' ' -f3) = $current ]] && local switch=true
    done
  done
}

[[ $1 = '' || $1 = 'mute' ]] && mute
[[ $1 = 'down' ]] && down
[[ $1 = 'up' ]] && up
[[ $1 = 'source' || $1 = 'sink' ]] && device $1

