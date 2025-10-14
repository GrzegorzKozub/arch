#!/usr/bin/env zsh

set -o verbose

# malcontent

sudo pacman -S --noconfirm malcontent

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

