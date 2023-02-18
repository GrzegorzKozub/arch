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
  sway-audio-idle-inhibit-git \
  swaylock-effects-git \
  waylogout-git

# experimental nvidia support

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  sudo cp `dirname $0`/usr/share/wayland-sessions/sway-nvidia.desktop /usr/share/wayland-sessions

  sudo pacman -S --noconfirm \
    vulkan-validation-layers

fi

# links

for APP in \
  swayimg
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

# dotfiles

. ~/code/dotfiles/sway.zsh

