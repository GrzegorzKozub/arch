#!/usr/bin/env zsh

set -o verbose

# vpn

nmcli connection delete apsis

sudo pacman -Rs --noconfirm \
  openconnect networkmanager-openconnect

sudo pacman -S --noconfirm \
  openvpn networkmanager-openvpn

# nmcli connection import type openvpn file apsis.ovpn
# nmcli connection modify apsis +vpn.data username=grko_vpn

# neovim

paru -S --aur --noconfirm \
  fswatch
