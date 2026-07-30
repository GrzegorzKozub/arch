#!/usr/bin/env bash
set -eo pipefail -ux

remove_color_profile() {
  set +e
  PROFILE=$(colormgr find-profile-by-filename "$1".icm |
    grep 'Profile ID' | sed -e 's/Profile ID:    //')
  [[ -n $PROFILE ]] && colormgr delete-profile "$PROFILE"
  rm -f "$HOME"/.local/share/icc/"$1".icm
  set -e
}

add_color_profile() {
  set +e
  DEVICE=$(colormgr find-device-by-property Model "$2")
  SOURCE_ICC="${BASH_SOURCE%/*}"/home/.local/share/icc/"$1".icm
  DEST_ICC="$HOME"/.local/share/icc/"$1".icm
  if echo "$DEVICE" | grep -q "$1" && cmp -s "$SOURCE_ICC" "$DEST_ICC"; then
    set -e
    return
  elif echo "$DEVICE" | grep -q "$1"; then
    PROFILE=$(colormgr find-profile-by-filename "$1".icm |
      grep 'Profile ID' | sed -e 's/Profile ID:    //')
    [[ -n $PROFILE ]] && colormgr delete-profile "$PROFILE"
    rm -f "$DEST_ICC"
  fi
  DEVICE=$(echo "$DEVICE" | grep 'Device ID' | sed -e 's/Device ID:     //')
  PROFILE=$(colormgr find-profile-by-filename "$1".icm |
    grep 'Profile ID' | sed -e 's/Profile ID:    //')
  if [[ -z $PROFILE ]]; then
    (exit 1)
    # shellcheck disable=SC2181
    while [[ ! $? == 0 ]]; do
      PROFILE=$(
        colormgr import-profile "${BASH_SOURCE%/*}"/home/.local/share/icc/"$1".icm |
          grep 'Profile ID' | sed -e 's/Profile ID:    //'
      )
    done
  fi
  until ERROR=$(colormgr device-add-profile "$DEVICE" "$PROFILE" 2>&1); do
    [[ $ERROR == *'already been added'* ]] && break
    sleep 1
  done
  set -e
}

if [[ ${1:-} == '--remove' ]]; then

  [[ $HOST == 'player' ]] && remove_color_profile 'mpg321urx'

  if [[ $HOST == 'worker' ]]; then
    remove_color_profile '27gp950-b'
    remove_color_profile '27ul850-w'
  fi

else

  [[ $HOST == 'player' ]] && add_color_profile 'mpg321urx' 'MPG321UX OLED'

  if [[ $HOST == 'worker' ]]; then
    add_color_profile '27gp950-b' 'LG ULTRAGEAR+'
    add_color_profile '27ul850-w' 'LG HDR 4K'
  fi

fi
