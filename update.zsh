#!/usr/bin/env zsh

set -o verbose

# update self

git pull

# update all packages

sudo pacman --noconfirm -Sy archlinux-keyring

sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

# remove unused packages

sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# clean package caches

sudo pacman --noconfirm -Sc
paru --aur -Sccd

# clean system logs

sudo journalctl --vacuum-time=3months

# remove obsolete dirs and files

[[ -d ~/.gnome ]] && rm -rf ~/.gnome

[[ -d ~/.cache/js-v8flags ]] && rm -rf ~/.cache/js-v8flags
[[ -d ~/.cache/yarn ]] && rm -rf ~/.cache/yarn
[[ -f ~/.yarnrc ]] && rm ~/.yarnrc

# merge *.pacnew and *.pacsave files

sudo DIFFPROG='nvim -d' pacdiff

# settings

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && . `dirname $0`/gnome.zsh
[[ $XDG_CURRENT_DESKTOP = 'KDE' ]] && . `dirname $0`/plasma.zsh

. `dirname $0`/settings.zsh
. `dirname $0`/links.zsh
. `dirname $0`/gdm.zsh

