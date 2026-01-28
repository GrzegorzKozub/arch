#!/usr/bin/env zsh

set -e -o verbose

# brightness

[[ $HOST = 'drifter' ]] && brightnessctl set 25%

# color

add_color_profile() {
  set +e
  DEVICE=$(colormgr find-device-by-property Model $2)
  [[ $(echo $DEVICE | grep $1) ]] && return
  DEVICE=$(echo $DEVICE | grep 'Device ID' | sed -e 's/Device ID:     //')
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
  colormgr device-add-profile $DEVICE $PROFILE
  set -e
}

[[ $HOST = 'player' ]] && add_color_profile 'mpg321urx' 'MPG321UX OLED'

if [[ $HOST = 'worker' ]]; then

  add_color_profile '27gp950-b' 'LG ULTRAGEAR+'
  add_color_profile '27ul850-w' 'LG HDR 4K'

fi

# sound

pactl list short sinks | cut -f1 | while read -r id; do
  pactl set-sink-volume $id 50%
done

pactl list short sources | cut -f1 | while read -r id; do
  pactl set-source-volume $id 100%
done

find() {
  pactl list "$1"s | grep --before-context 1 "Description: $2" | head -n1 | sed 's/.*Name: //'
}

[[ $HOST = 'player' ]] &&
  pactl set-default-sink $(find sink 'Schiit Magni Unity Analog Stereo')

[[ $HOST == 'worker' ]] && {

  pactl set-default-sink $(find sink 'Edifier M60 Analog Stereo')

  MIC=$(find source 'Wireless microphone Analog Stereo') # Hollyland Lark M2

  [[ $MIC ]] &&
    pactl set-default-source $MIC ||
    pactl set-default-source $(find source 'C922 Pro Stream Webcam Analog Stereo')

}

pactl set-sink-volume @DEFAULT_SINK@ 50%
pactl set-source-volume @DEFAULT_SOURCE@ 100%

[[ $HOST = 'drifter' ]] && pactl set-sink-mute @DEFAULT_SINK@ 1

# dns with systemd-resolved

while IFS= read -r conn; do

  nmcli connection modify "$conn" ipv4.ignore-auto-dns yes
  nmcli connection modify "$conn" ipv6.ignore-auto-dns yes

  nmcli connection modify "$conn" connection.dns-over-tls 2

done < <(nmcli --terse --fields NAME,TYPE connection show | awk -F: '$2 ~ /ethernet|wireless/ {print $1}')

# wifi

if [[ $HOST =~ ^(player|worker)$ ]]; then
  nmcli radio wifi off
fi

# bluetooth

rfkill block bluetooth # causes 'bluetoothd[...]: Failed to set mode: Failed (0x03)' which is fine

# power

if [[ $HOST = 'drifter' ]]; then
  powerprofilesctl set power-saver
else
  powerprofilesctl set balanced
fi

