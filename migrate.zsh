#!/usr/bin/env zsh

set -o verbose

# 7z

paru -Rs --aur --noconfirm 7-zip-full
sudo pacman -S --noconfirm 7zip

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

