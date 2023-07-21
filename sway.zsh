#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  xdg-desktop-portal-wlr \
  sway \
  swaybg \
  swayidle swaylock \
  waybar wofi \
  brightnessctl polkit \
  gammastep \
  pavucontrol \
  grim slurp \
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

if [[ $HOST = 'player' ]]; then

  sudo cp `dirname $0`/usr/share/wayland-sessions/sway-nvidia.desktop /usr/share/wayland-sessions

  sudo pacman -S --noconfirm \
    vulkan-validation-layers

fi

# dotfiles

. ~/code/dotfiles/sway.zsh

