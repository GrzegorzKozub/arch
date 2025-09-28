#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  libnma \
  networkmanager-openvpn \
  openvpn

# connections

for FILE in ~/code/keys/openvpn/webscript-*.ovpn; do

  CONN=$(basename -- $FILE .ovpn)

  [[ $(nmcli connection | grep "$CONN ") ]] && nmcli connection delete $CONN

  nmcli connection import type openvpn file $FILE
  nmcli connection modify $CONN +vpn.data password-flags=2

done

# nmcli connection up webscript-stage --ask

