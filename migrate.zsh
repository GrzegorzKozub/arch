#!/usr/bin/env zsh

set -o verbose

# https://aur.archlinux.org/packages/aws-cli-v2

sudo sed -ie \
  's/IgnorePkg    = aws-cli-v2/#IgnorePkg   =/' \
  /etc/pacman.conf

sudo pacman -Rs --noconfirm \
  aws-cli-v2

paru -S --aur --noconfirm --nocheck \
  aws-cli-v2

# https://github.com/flexagoon/rounded-window-corners

paru -Rs --noconfirm \
  gnome-shell-extension-rounded-window-corners-git

paru -S --aur --noconfirm \
  gnome-shell-extension-rounded-window-corners-reborn

