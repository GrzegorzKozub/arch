#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  plasma-desktop plasma-nm plasma-pa \
  bluedevil powerdevil \
  khotkeys kscreen \
  breeze-gtk \
  plasma-systemmonitor

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
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
done

for APP in \
  kdesystemsettings \
  org.kde.klipper
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
done

for APP in \
  org.kde.plasma-systemmonitor
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNotShowIn=GNOME;' ~/.local/share/applications/$APP.desktop
done

