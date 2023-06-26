#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  xdg-desktop-portal-hyprland \
  hyprland \
  hyprpaper \
  waybar wofi \
  gammastep \
  grim slurp \
  foot

# foot

for APP in \
  org.codeberg.dnkl.foot-server \
  org.codeberg.dnkl.foot \
  org.codeberg.dnkl.footclient
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iStartupWMClass=foot' $XDG_DATA_HOME/applications/$APP.desktop
done

for APP in \
  org.codeberg.dnkl.foot-server \
  org.codeberg.dnkl.footclient
do
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# dotfiles

. ~/code/dotfiles/hyprland.zsh

