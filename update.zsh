#!/usr/bin/env zsh

set -o verbose

# update self

git pull

# update all packages

sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

# remove unused packages

sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# clean package caches

sudo pacman --noconfirm -Sc
paru --aur -Sccd

# clean system logs

sudo journalctl --vacuum-time=3months

# remove obsolete dirs

[[ -d ~/.gnome ]] && rm -rf ~/.gnome

# merge *.pacnew and *.pacsave files

sudo pacdiff

# gdm, gnome and links

. `dirname $0`/gdm.zsh
. `dirname $0`/gnome.zsh
. `dirname $0`/links.zsh

# keys and passwords

pushd ~/code/keys && git pull && popd
pushd ~/code/passwords && git pull && popd

