#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  libnma \
  networkmanager-openvpn \
  openvpn

  # openresolv
  # systemd-resolvconf

# paru -S --aur --noconfirm \
#   openvpn-update-systemd-resolved

# sudo systemctl enable systemd-resolved.service

# connections

DIR=~/code/keys/openvpn
CONN=apsis

[[ $(nmcli connection | grep $CONN) ]] && nmcli connection delete $CONN

nmcli connection import type openvpn file $DIR/$CONN.ovpn

nmcli connection modify $CONN +vpn.data username=grko_vpn
nmcli connection modify $CONN +vpn.data password-flags=2

nmcli connection modify $CONN ipv4.dns-search 'apsis.local'

nmcli connection modify $CONN ipv4.never-default 'yes'
nmcli connection modify $CONN ipv6.never-default 'yes'

for FILE in $DIR/*.ovpn; do

  CONN=$(basename -- $FILE .ovpn)

  [[ $CONN = 'apsis' ]] && continue

  [[ $(nmcli connection | grep $CONN) ]] && nmcli connection delete $CONN

  nmcli connection import type openvpn file $FILE
  nmcli connection modify $CONN +vpn.data password-flags=2

done

# nmcli connection up apsis --ask

