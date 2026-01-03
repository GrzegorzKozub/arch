#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  microsoft-edge-stable-bin

# https://github.com/MicrosoftEdge/DevTools/issues/278

DIR=microsoft-edge/Default
[[ -d $XDG_CONFIG_HOME/$DIR ]] || mkdir -p $XDG_CONFIG_HOME/$DIR
cp `dirname $0`/home/$USER/.config/$DIR/HubApps $XDG_CONFIG_HOME/$DIR/

# links

cp /usr/share/applications/microsoft-edge.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=Edge/' $XDG_DATA_HOME/applications/microsoft-edge.desktop

# cleanup

`dirname $0`/packages.zsh

# dotfiles

~/code/dot/edge.zsh

