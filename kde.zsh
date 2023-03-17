#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  plasma-desktop plasma-nm plasma-pa \
  plasma-wayland-session xdg-desktop-portal-kde \
  bluedevil powerdevil \
  khotkeys kscreen \
  breeze-gtk \
  plasma-systemmonitor dolphin \
  hunspell hunspell-en_us hunspell-pl

# links

for APP in \
  assistant \
  designer \
  gnome-system-monitor-kde \
  linguist \
  org.kde.kmenuedit \
  org.kde.kuserfeedback-console \
  qdbusviewer
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

for APP in \
  kdesystemsettings \
  org.kde.klipper
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

for APP in \
  org.kde.dolphin \
  org.kde.plasma-systemmonitor
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNotShowIn=GNOME;' $XDG_DATA_HOME/applications/$APP.desktop
done

