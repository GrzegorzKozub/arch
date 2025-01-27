#!/usr/bin/env zsh

set -o verbose

# refine

# https://aur.archlinux.org/packages/refine
# https://gitlab.gnome.org/TheEvilSkeleton/Refine/-/issues/43

# paru -S --aur --noconfirm refine

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

