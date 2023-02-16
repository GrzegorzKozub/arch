#!/usr/bin/env zsh

set -e -o verbose

# sway

sudo pacman -S --noconfirm \
  sway \
  brightnessctl polkit \
  swaybg swayidle \
  waybar \
  wofi \
  grim slurp xdg-desktop-portal-wlr \
  swayimg

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended \
  swaylock-effects-git \
  waylogout-git

. ~/code/dotfiles/sway.zsh

