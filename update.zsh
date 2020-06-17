#!/usr/bin/env zsh

set -o verbose

# update all packages

sudo pacman --noconfirm -Syu
yay --aur --noconfirm -Syu

# remove unused packages

sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# clean package caches

sudo pacman --noconfirm -Sc
yay --aur --noconfirm -Sc

