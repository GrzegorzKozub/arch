#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  xdg-desktop-portal-hyprland \
  hyprland \
  hyprpaper \
  waybar wofi \
  gammastep \
  grim slurp

# dotfiles

. ~/code/dotfiles/hyprland.zsh

