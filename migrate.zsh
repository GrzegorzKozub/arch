#!/usr/bin/env zsh

set -o verbose

# argyllcms

sudo pacman -S --noconfirm argyllcms

# apsis

. `dirname $0`/apsis.zsh

# dconf

dconf reset -f /io/github/

# dust

rm -f ~/.config/dust
sudo pacman -Rs --noconfirm dust

# intel

sudo pacman -Rs --noconfirm libva-vdpau-driver

# mission-center

sudo pacman -S --noconfirm mission-center

# refine

# https://aur.archlinux.org/packages/refine
# https://gitlab.gnome.org/TheEvilSkeleton/Refine/-/issues/43

# paru -S --aur --noconfirm refine

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

