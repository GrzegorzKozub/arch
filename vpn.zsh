#!/usr/bin/env zsh

set -e -o verbose

if [[ $1 == 'apsis' ]]; then

  # packages

  paru -S --aur --noconfirm \
    openvpn3

  # connections

  openvpn3 config-import \
    --config ~/code/keys/openvpn/apsis.ovpn \
    --name apsis \
    --persistent

  # openvpn3 session-start --config apsis
  # openvpn3 session-manage --config apsis --disconnect
  # openvpn3 sessions-list

fi

if [[ $1 == 'audience' ]]; then

  # packages

  sudo pacman -S --noconfirm \
    networkmanager-strongswan \
    strongswan

fi

if [[ $1 == 'webscript' ]]; then

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

fi
