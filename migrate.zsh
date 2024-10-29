#!/usr/bin/env zsh

set -o verbose

# shellcheck

paru -S --aur --noconfirm shellcheck-bin

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

