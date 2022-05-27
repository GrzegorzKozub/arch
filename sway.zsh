#!/usr/bin/env zsh

set -e -o verbose

# sway

sudo pacman -S --noconfirm \
  sway \
  brightnessctl \
  polkit \
  swaybg swayidle swaylock \
  bemenu-wayland bemenu \
  waybar

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended

. ~/code/dotfiles/sway.zsh

