#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  obs-studio \
  shotcut

# links

APP=org.shotcut.Shotcut
cp /usr/share/applications/$APP.desktop ~/.local/share/applications
sed -i \
  -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' \
  ~/.local/share/applications/$APP.desktop

