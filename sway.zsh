#!/usr/bin/env zsh

set -e -o verbose

# sway

sudo pacman -S --noconfirm \
  sway \
  brightnessctl polkit \
  gammastep \
  swaybg swayidle swaylock \
  pavucontrol \
  waybar \
  wofi \
  grim slurp xdg-desktop-portal-wlr \
  swayimg

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended \
  chayang-git \
  waylogout-git

# experimental nvidia support

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  sudo cp `dirname $0`/usr/share/wayland-sessions/sway-nvidia.desktop /usr/share/wayland-sessions

  sudo pacman -S --noconfirm \
    vulkan-validation-layers

fi

# links

for APP in \
  gammastep \
  gammastep-indicator \
  pavucontrol \
  swayimg
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

# dotfiles

. ~/code/dotfiles/sway.zsh

