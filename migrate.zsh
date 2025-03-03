#!/usr/bin/env zsh

set -o verbose

# rga

sudo pacman -S --noconfirm ripgrep-all

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

