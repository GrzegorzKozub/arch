#!/usr/bin/env bash
set -eo pipefail -ux

profile_id() {
  colormgr find-profile-by-filename "$1".icm |
    grep 'Profile ID' | sed -e 's/Profile ID:    //'
}

add() {
  DEVICE=$(colormgr find-device-by-property Model "$2" || true)
  SRC="${BASH_SOURCE%/*}"/home/.local/share/icc/"$1".icm
  DST="$XDG_DATA_HOME"/icc/"$1".icm

  ASSIGNED=0
  echo "$DEVICE" | grep -q "$1" && ASSIGNED=1

  if ((ASSIGNED)) && cmp -s "$SRC" "$DST"; then
    return
  elif ((ASSIGNED)); then
    PROFILE=$(profile_id "$1" || true)
    [[ -n $PROFILE ]] && { colormgr delete-profile "$PROFILE" || true; }
    rm -f "$DST"
  fi

  PROFILE=$(profile_id "$1" || true)
  until [[ -n $PROFILE ]]; do
    colormgr import-profile "$SRC" &> /dev/null || true
    PROFILE=$(profile_id "$1" || true)
  done

  DEVICE=$(echo "$DEVICE" | grep 'Device ID' | sed -e 's/Device ID:     //')
  until ERR=$(colormgr device-add-profile "$DEVICE" "$PROFILE" 2>&1) ||
    [[ $ERR == *'already been added'* ]]; do
    sleep 1
  done
}

remove() {
  PROFILE=$(profile_id "$1" || true)
  [[ -n $PROFILE ]] && { colormgr delete-profile "$PROFILE" || true; }
  rm -f "$XDG_DATA_HOME"/icc/"$1".icm
}

if [[ -z ${1:-} ]]; then
  [[ $HOST == 'drifter' ]] && add 'xps13' '0x14fa'
  [[ $HOST == 'player' ]] && add 'mpg321urx' 'MPG321UX OLED'
  if [[ $HOST == 'worker' ]]; then
    add '27gp950-b' 'LG ULTRAGEAR+'
    add '27ul850-w' 'LG HDR 4K'
  fi
fi

if [[ ${1:-} == 'remove' ]]; then
  [[ $HOST == 'drifter' ]] && remove 'xps13'
  [[ $HOST == 'player' ]] && remove 'mpg321urx'
  if [[ $HOST == 'worker' ]]; then
    remove '27gp950-b'
    remove '27ul850-w'
  fi
fi
