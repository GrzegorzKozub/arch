#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  obs-studio \
  shotcut

# links

LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications
APP=org.shotcut.Shotcut.desktop

cp /usr/share/applications/$APP $LOCAL
sed -i -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' $LOCAL/$APP

