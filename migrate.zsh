#!/usr/bin/env zsh

set -o verbose

# 7z

paru -Rs --aur --noconfirm 7-zip-full
sudo pacman -S --noconfirm 7zip

# bat

bat cache --build

pushd $XDG_CONFIG_HOME/silicon
silicon --build-cache
popd

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

