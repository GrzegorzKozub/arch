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
  VOL=$(volume)
  ((DELTA = VOL <= 95 ? 5 : 100 - VOL))
  pactl set-sink-volume @DEFAULT_SINK@ +$DELTA%
  volume
}

[[ ${1:-} =~ ^(sink|source)$ ]] && {
  [[ $1 == 'sink' ]] && SINK=1
  [[ $1 == 'source' ]] && SOURCE=1

  [[ ${SINK:-} ]] && ALL=$(pactl list short sinks | cut -f2) && DEFAULT='Default Sink'
  [[ ${SOURCE:-} ]] && ALL=$(pactl list short sources | cut -f2) && DEFAULT='Default Source'

  default() {
    pactl info | grep "$DEFAULT" | cut -d' ' -f3
  }

  show() {
    pactl list "$1" | grep --context=1 "$2" | grep 'Description' | sed -e 's/.*Description: //'
  }

  while true; do
    while IFS= read -r current; do
      if [[ ${SWITCH:-} ]]; then
        [[ ${SINK:-} ]] && pactl set-default-sink "$current"
        [[ ${SOURCE:-} ]] && pactl set-default-source "$current"
        if [[ $(default) == "$current" ]]; then
          [[ ${SINK:-} ]] && show 'sinks' "$current"
          [[ ${SOURCE:-} ]] && show 'sources' "$current"
          exit
        fi
      fi
      [[ $(default) == "$current" ]] && SWITCH=1
    done < <(echo "$ALL")
  done
}

[[ -z ${1:-} || ${1:-} == 'mute' ]] && {
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  pactl get-sink-mute @DEFAULT_SINK@ | sed -e 's/Mute: //'
}
