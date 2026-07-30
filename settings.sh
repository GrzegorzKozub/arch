#!/usr/bin/env bash
set -eo pipefail -ux

# brightness

[[ $HOST == 'drifter' ]] && brightnessctl set 25%

# color

"${BASH_SOURCE%/*}"/icc.sh

# sound

pactl list short sinks | cut -f1 | while read -r ID; do
  pactl set-sink-volume "$ID" 50%
done

pactl list short sources | cut -f1 | while read -r ID; do
  pactl set-source-volume "$ID" 100%
done

find() {
  pactl list "$1"s | grep --before-context 1 "Description: $2" | head -n1 | sed 's/.*Name: //'
}

[[ $HOST == 'player' ]] &&
  pactl set-default-sink "$(find sink 'Schiit Magni Unity Analog Stereo')"

[[ $HOST == 'worker' ]] && {

  pactl set-default-sink "$(find sink 'EDIFIER M60 Analog Stereo')"

  MIC=$(find source 'Wireless microphone Analog Stereo') # Hollyland Lark M2

  if [[ $MIC ]]; then
    pactl set-default-source "$MIC"
  else
    pactl set-default-source "$(find source 'C922 Pro Stream Webcam Analog Stereo')"
  fi

}

pactl set-sink-volume @DEFAULT_SINK@ 50%
pactl set-source-volume @DEFAULT_SOURCE@ 100%

[[ $HOST == 'drifter' ]] && pactl set-sink-mute @DEFAULT_SINK@ 1

# dns with systemd-resolved

while IFS= read -r conn; do

  nmcli connection modify "$conn" ipv4.ignore-auto-dns yes
  nmcli connection modify "$conn" ipv6.ignore-auto-dns yes

  nmcli connection modify "$conn" connection.dns-over-tls 2

done < <(nmcli --terse --fields NAME,TYPE connection show | awk -F: '$2 ~ /ethernet|wireless/ {print $1}')

# wifi

[[ $HOST =~ ^(player|worker)$ ]] && rfkill block wifi # noctalia: nmcli radio wifi off

# bluetooth

rfkill block bluetooth # noctalia: bluetoothctl power off

# power

if [[ $HOST == 'drifter' ]]; then
  powerprofilesctl set power-saver
else
  powerprofilesctl set balanced
fi
