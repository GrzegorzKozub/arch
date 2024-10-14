#!/usr/bin/env zsh

set -o verbose

# procs

sudo pacman -S --noconfirm procs

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

