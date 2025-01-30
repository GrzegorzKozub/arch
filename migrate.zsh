#!/usr/bin/env zsh

set -o verbose

# pacman

sudo sed -i 's/^OPTIONS=\(.*\) debug\(.*\)$/OPTIONS=\1 !debug\2/' /etc/makepkg.conf

# refine

paru -S --aur --noconfirm refine

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

