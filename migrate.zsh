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

  # openresolv
  # systemd-resolvconf

# paru -S --aur --noconfirm \
#   openvpn-update-systemd-resolved

# sudo systemctl enable systemd-resolved.service

. ~/code/keys/init.zsh
. ~/code/keys/install.zsh

