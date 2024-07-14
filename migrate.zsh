#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  git-credential-gopass \
  gnome-characters

rm $XDG_DATA_HOME/applications/satty.desktop

sudo pacman -Rs --noconfirm \
  foot

for APP in \
  org.codeberg.dnkl.foot-server \
  org.codeberg.dnkl.foot \
  org.codeberg.dnkl.footclient
do
  rm $XDG_DATA_HOME/applications/$APP.desktop
done

rm -rf $XDG_CONFIG_HOME/foot

gsettings set org.gnome.desktop.interface cursor-size 24

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

# manual

# vrr
