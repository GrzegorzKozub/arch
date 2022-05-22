#!/usr/bin/env zsh

set -e -o verbose

# sway

sudo pacman -S --noconfirm \
  sway \
  brightnessctl \
  polkit \
  swayidle swaylock swaybg \
  bemenu-wayland bemenu \
  waybar otf-font-awesome

paru -S --aur --noconfirm \
  wob

. ~/code/dotfiles/sway.zsh

