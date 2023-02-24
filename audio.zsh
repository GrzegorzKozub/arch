#!/usr/bin/env zsh

set -e

() {

[[ $1 = '' || $1 = 'sink' ]] && local snk=true
[[ $1 = 'source' ]] && local src=true

[[ $snk || $src ]] || exit

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

} $1

