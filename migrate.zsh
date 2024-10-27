#!/usr/bin/env zsh

set -o verbose

# git-extras

paru -Rs --noconfirm git-extras

# zed

sudo pacman -S --noconfirm zed

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

