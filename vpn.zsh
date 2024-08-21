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

# apsis

[[ $(nmcli connection | grep apsis) ]] && nmcli connection delete apsis

nmcli connection import type openvpn file ~/code/keys/openvpn/apsis.ovpn

nmcli connection modify apsis +vpn.data username=grko_vpn
nmcli connection modify apsis +vpn.data password-flags=2

nmcli connection modify apsis ipv4.dns-search 'apsis.local'

nmcli connection modify apsis ipv4.never-default 'yes'
nmcli connection modify apsis ipv6.never-default 'yes'

# nmcli connection up apsis --ask

# webscript-stage

[[ $(nmcli connection | grep webscript-stage) ]] && nmcli connection delete webscript-stage

nmcli connection import type openvpn file ~/code/keys/openvpn/webscript-stage.ovpn

nmcli connection modify webscript-stage +vpn.data password-flags=2
