#!/usr/bin/env zsh

set -o verbose

# update all packages

sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

# remove unused packages

sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# clean package caches

sudo pacman --noconfirm -Sc
paru --aur --noconfirm -Sccd

# clean system logs

sudo journalctl --vacuum-time=3months

# remove obsolete dirs

[[ -d ~/.gnome ]] && rm -rf ~/.gnome

# merge *.pacnew and *.pacsave files

sudo pacdiff

