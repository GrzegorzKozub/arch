#!/usr/bin/env zsh

set -o verbose

# electron

sudo pacman -Rs --noconfirm electron32
rm ~/.local/share/applications/electron32.desktop

# icons

rm -rf ~/.local/share/icons

sudo pacman -Rs --noconfirm papirus-icon-theme
paru -S --aur --needed --noconfirm papirus-icon-theme-git

# pacman

sudo sed -i 's/^OPTIONS=\(.*\) debug\(.*\)$/OPTIONS=\1 !debug\2/' /etc/makepkg.conf

# refine

paru -S --aur --noconfirm refine

# xh

sudo pacman -S --noconfirm xh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

