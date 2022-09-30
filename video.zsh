#!/usr/bin/env zsh

set -e -o verbose

# video

sudo pacman -S --noconfirm \
  obs-studio \
  shotcut

# links

for APP in \
  org.shotcut.Shotcut
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' \
    ~/.local/share/applications/$APP.desktop
done

