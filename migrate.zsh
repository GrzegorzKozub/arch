#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  nushell

pushd ~/code/dotfiles

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  nushell

popd

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

