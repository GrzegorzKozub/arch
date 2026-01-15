#!/usr/bin/env bash
set -eo pipefail -u

volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\{1,3\}%' | head -n 1 | sed 's/%//'
}

[[ ${1:-} == 'down' ]] && {
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  volume
}

[[ ${1:-} == 'up' ]] && {
  [[ "$(volume)" -lt 100 ]] && pactl set-sink-volume @DEFAULT_SINK@ +5%
  volume
}

[[ ${1:-} =~ ^(source|sink)$ ]] && {
  [[ $1 == 'sink' ]] && snk=true
  [[ $1 == 'source' ]] && src=true

  [[ $snk ]] && all=$(pactl list short sinks | cut -f2) && default='Default Sink'
  [[ $src ]] && all=$(pactl list short sources | cut -f2) && default='Default Source'

  show() {
    pactl list "$1" | grep --context=1 "$2" | grep 'Description' | sed -e 's/.*Description: //'
  }

  while true; do
    echo "$all" | while read -r current; do
      if [[ $switch ]]; then
        [[ $snk ]] && pactl set-default-sink "$current"
        [[ $src ]] && pactl set-default-source $current
        if [[ $(pactl info | grep $default | cut -d' ' -f3) = $current ]]; then
          [[ $snk ]] && show 'sinks' $current
          [[ $src ]] && show 'sources' $current
          return
        fi
      fi
      [[ $(pactl info | grep $default | cut -d' ' -f3) = $current ]] && switch=true
    done
  done
}

[[ -z ${1:-} || ${1:-} == 'mute' ]] && {
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  pactl get-sink-mute @DEFAULT_SINK@ | sed -e 's/Mute: //'
}
