#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  plasma-desktop plasma-nm plasma-pa \
  bluedevil powerdevil \
  khotkeys kscreen \
  breeze-gtk \
  plasma-systemmonitor dolphin

# links

USR=/usr/share/applications
LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications

for APP in \
  assistant \
  designer \
  gnome-system-monitor-kde \
  linguist \
  org.kde.kmenuedit \
  org.kde.kuserfeedback-console \
  qdbusviewer
do
  cp $USR/$APP.desktop $LOCAL
  sed -i '2iNoDisplay=true' $LOCAL/$APP.desktop
done

for APP in \
  kdesystemsettings \
  org.kde.klipper
do
  cp $USR/$APP.desktop $LOCAL
  sed -i '2iNoDisplay=true' $LOCAL/$APP.desktop
done

for APP in \
  org.kde.dolphin \
  org.kde.plasma-systemmonitor
do
  cp $USR/$APP.desktop $LOCAL
  sed -i '2iNotShowIn=GNOME;' $LOCAL/$APP.desktop
done

