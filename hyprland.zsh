#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  hyprland \
  hyprpaper \
  wofi \
  xdg-desktop-portal-hyprland \
  qt5-wayland qt6-wayland

# dotfiles

. ~/code/dotfiles/hyprland.zsh

