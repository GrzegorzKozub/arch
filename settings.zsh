#!/usr/bin/env zsh

set -e -o verbose

# color

add_color_profile() {
  set +e
  PROFILE=$(colormgr find-profile-by-filename $1.icm |
    grep 'Profile ID' | sed -e 's/Profile ID:    //')
  if [[ -z $PROFILE ]]; then
    (exit 1)
    while [[ ! $? = 0 ]]; do
      PROFILE=$(
        colormgr import-profile `dirname $0`/home/$USER/.local/share/icc/$1.icm |
          grep 'Profile ID' | sed -e 's/Profile ID:    //')
    done
  fi
  DEVICE=$(colormgr find-device-by-property Model $2 |
    grep 'Device ID' | sed -e 's/Device ID:     //')
  colormgr device-add-profile $DEVICE $PROFILE
  set -e
}

[[ $HOST = 'player' ]] && add_color_profile '27gp950-b' 'LG ULTRAGEAR+'

if [[ $HOST = 'worker' ]]; then

  add_color_profile '27ul850-w' 'LG HDR 4K'
  add_color_profile '27ud88-w' 'LG Ultra HD'

fi

# sound

pactl list short sinks | cut -f1 | while read -r id; do
  pactl set-sink-volume $id 50%
done

pactl list short sources | grep -v 'monitor' | cut -f1 | while read -r id; do
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

# apps

xdg-mime default nvim.desktop text/plain

xdg-mime default mpv.desktop audio/mpeg
xdg-mime default mpv.desktop audio/ogg

xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/x-matroska

xdg-mime default brave-browser.desktop x-scheme-handler/mailto
xdg-mime default brave-browser.desktop text/calendar

# xdg-mime default slack.desktop x-scheme-handler/slack

