#!/usr/bin/env zsh

set -o verbose

# git-extras

paru -Rs --noconfirm git-extras

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

