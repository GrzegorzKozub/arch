#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  openvpn networkmanager-openvpn

  # openresolv
  # systemd-resolvconf

# paru -S --aur --noconfirm \
#   openvpn-update-systemd-resolved

# sudo systemctl enable systemd-resolved.service

# connection

[[ $(nmcli connection | grep apsis) ]] && nmcli connection delete apsis

nmcli connection import type openvpn file ~/code/keys/openvpn/apsis.ovpn

nmcli connection modify apsis +vpn.data username=grko_vpn
nmcli connection modify apsis +vpn.data password-flags=2

nmcli connection modify apsis ipv4.dns-search 'apsis.local'

nmcli connection up apsis --ask

