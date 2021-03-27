#!/usr/bin/env zsh

set -o verbose

# update all packages

sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

# remove unused packages

sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# clean package caches

sudo pacman --noconfirm -Sc
paru --aur --noconfirm -Scc

# clean system logs

sudo journalctl --vacuum-time=3months

