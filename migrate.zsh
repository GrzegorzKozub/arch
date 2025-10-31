#!/usr/bin/env zsh

set -o verbose

# seahorse

sudo pacman -S --noconfirm seahorse

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

