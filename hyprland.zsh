#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  hyprland-git

sudo pacman -S --noconfirm \
  xdg-desktop-portal-hyprland \
  hyprpaper \
  swayidle swaylock \
  waybar wofi \
  gammastep \
  brightnessctl \
  pavucontrol \
  grim slurp

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended \
  chayang-git

# polkit swayimg

# links

for APP in \
  gammastep \
  gammastep-indicator \
  pavucontrol
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# dotfiles

. ~/code/dotfiles/hyprland.zsh

