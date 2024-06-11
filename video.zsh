#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  obs-studio \
  shotcut

# sudo pacman -S --noconfirm \
#   libjpeg6-turbo \
#   jre-openjdk \
#   opencl-nvidia

# paru -S --aur --noconfirm \
#   davinci-resolve

# links

cp /usr/share/applications/org.shotcut.Shotcut.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' $XDG_DATA_HOME/applications/org.shotcut.Shotcut.desktop

