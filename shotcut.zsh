#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  shotcut

# links

cp /usr/share/applications/org.shotcut.Shotcut.desktop $XDG_DATA_HOME/applications
sed -i \
  -e 's/^Exec=/Exec=env QT_QPA_PLATFORM=wayland /' \
  $XDG_DATA_HOME/applications/org.shotcut.Shotcut.desktop

# cleanup

. `dirname $0`/packages.zsh

