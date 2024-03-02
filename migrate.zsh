#!/usr/bin/env zsh

set -o verbose

sudo sed -i "s/PKGEXT='.pkg.tar.zst'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf

rm -rf $XDG_DATA_HOME/applications/lstopo.desktop

