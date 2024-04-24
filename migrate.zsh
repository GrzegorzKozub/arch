#!/usr/bin/env zsh

set -o verbose

nmcli connection delete apsis

sudo pacman -Rs --noconfirm \
  openconnect networkmanager-openconnect

sudo pacman -S --noconfirm \
  openvpn networkmanager-openvpn

