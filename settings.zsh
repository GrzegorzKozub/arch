#!/usr/bin/env zsh

set -e -o verbose

# color

if [[ $HOST = 'worker' ]]; then

  add_color_profile() {
    set +e
    PROFILE=$(colormgr find-profile-by-filename $1.icm |
      grep 'Profile ID' | sed -e 's/Profile ID:    //')
    if [[ -z $PROFILE ]]; then
      (exit 1)
      while [[ ! $? = 0 ]]; do
        echo 'import'
        PROFILE=$(
          colormgr import-profile `dirname $0`/home/$USER/.local/share/icc/$1.icm |
            grep 'Profile ID' | sed -e 's/Profile ID:    //')
      done
    fi
    echo $PROFILE
    DEVICE=$(colormgr find-device-by-property Model $2 |
      grep 'Device ID' | sed -e 's/Device ID:     //')
    echo $DEVICE
    colormgr device-add-profile $DEVICE $PROFILE
    set -e
  }

  add_color_profile '27ul850-w' 'LG HDR 4K'
  add_color_profile '27ud88-w' 'LG Ultra HD'

fi

# sound

pactl list short sinks | cut -f1 | while read -r id; do
  pactl set-sink-volume $id 50%
done

pactl list short sources | cut -f1 | while read -r id; do
  pactl set-source-volume $id 50%
done

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

