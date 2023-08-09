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

# links

for APP in \
  gammastep \
  gammastep-indicator
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# dotfiles

. ~/code/dotfiles/hyprland.zsh

