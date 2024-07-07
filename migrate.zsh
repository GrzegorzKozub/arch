#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  git-credential-gopass

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

