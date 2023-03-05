#!/usr/bin/env zsh

set -e -o verbose

# packages

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
  chayang-git

# links

for APP in \
  gammastep \
  gammastep-indicator \
  pavucontrol \
  swayimg
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# experimental nvidia support

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  sudo cp `dirname $0`/usr/share/wayland-sessions/sway-nvidia.desktop /usr/share/wayland-sessions

  sudo pacman -S --noconfirm \
    vulkan-validation-layers

fi

# dotfiles

. ~/code/dotfiles/sway.zsh

