#!/usr/bin/env zsh

set -o verbose

# migrate

paru -S --aur \
  tmux-git

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

