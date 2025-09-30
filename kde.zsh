#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  plasma-desktop plasma-nm plasma-pa \
  xdg-desktop-portal-kde \
  bluedevil powerdevil \
  kscreen \
  breeze-gtk \
  plasma-systemmonitor dolphin \
  hunspell hunspell-en_us hunspell-pl

# links

for APP in \
  assistant \
  designer \
  gnome-system-monitor-kde \
  kdesystemsettings \
  linguist \
  org.kde.kmenuedit \
  qdbusviewer
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

