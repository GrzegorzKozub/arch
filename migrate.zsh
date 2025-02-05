#!/usr/bin/env zsh

set -o verbose

# electron

sudo pacman -Rs --noconfirm electron32

# pacman

sudo sed -i 's/^OPTIONS=\(.*\) debug\(.*\)$/OPTIONS=\1 !debug\2/' /etc/makepkg.conf

# refine

paru -S --aur --noconfirm refine

# xh

sudo pacman -S --noconfirm xh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

