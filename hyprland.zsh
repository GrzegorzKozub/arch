#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  xdg-desktop-portal-hyprland \
  hyprland \
  hyprpaper \
  swayidle swaylock \
  waybar wofi \
  gammastep \
  brightnessctl \
  grim slurp

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended \
  chayang-git

# dotfiles

. ~/code/dotfiles/hyprland.zsh

