#!/usr/bin/env zsh

set -e -o verbose

# sway

sudo pacman -S --noconfirm \
  sway \
  brightnessctl \
  polkit \
  swaybg swayidle \
  bemenu-wayland bemenu \
  waybar

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended \
  swaylock-effects-git \
  waylogout-git

. ~/code/dotfiles/sway.zsh

