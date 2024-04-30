#!/usr/bin/env zsh

set -o verbose

# https://aur.archlinux.org/packages/aws-cli-v2

sudo sed -ie \
  's/#IgnorePkg   =/IgnorePkg    = aws-cli-v2/' \
  /etc/pacman.conf

# neovim

paru -S --aur --noconfirm \
  fswatch

# vpn

nmcli connection delete apsis

sudo pacman -Rs --noconfirm \
  openconnect networkmanager-openconnect

sudo pacman -S --noconfirm \
  openvpn networkmanager-openvpn

# nmcli connection import type openvpn file apsis.ovpn
# nmcli connection modify apsis +vpn.data username=grko_vpn

