#!/usr/bin/env zsh

set -e -o verbose

# kde

sudo pacman -S --noconfirm \
  plasma-desktop plasma-nm plasma-pa \
  bluedevil powerdevil \
  khotkeys kscreen \
  breeze-gtk \
  kde-gtk-config \
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
  EXEC=$(cat /usr/share/applications/$APP.desktop | grep '^Exec=')
  printf "[Desktop Entry]\n%s\nNoDisplay=true" $EXEC > ~/.local/share/applications/$APP.desktop
done

for APP in \
  kdesystemsettings \
  org.kde.klipper
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^NotShowIn=KDE;$/NotShowIn=GNOME;KDE;/' \
    ~/.local/share/applications/$APP.desktop
done

for APP in \
  org.kde.plasma-systemmonitor
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  echo 'NotShowIn=GNOME;' >> ~/.local/share/applications/$APP.desktop
done

