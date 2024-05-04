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

. ~/code/keys/init.zsh

