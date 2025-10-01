#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  obs-studio \
  shotcut

  # linux-headers v4l2loopback-dkms

# links

for APP in \
  com.obsproject.Studio \
  org.shotcut.Shotcut
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e 's/^Exec=/Exec=env QT_QPA_PLATFORM=wayland /' \
    $XDG_DATA_HOME/applications/$APP.desktop
done

# cleanup

. `dirname $0`/packages.zsh

