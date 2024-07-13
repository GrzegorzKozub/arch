#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  git-credential-gopass

rm $XDG_DATA_HOME/applications/satty.desktop

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

# manual

