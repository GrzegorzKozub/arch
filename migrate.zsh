#!/usr/bin/env zsh

set -o verbose

# obsidian

[[ -f $XDG_CONFIG_HOME/obsidian/user-flags.conf ]] || {

  mv $XDG_CONFIG_HOME/obsidian ~/Downloads

  pushd ~/code/dot
  stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow obsidian
  popd

  mv ~/Downloads/obsidian/* $XDG_CONFIG_HOME/obsidian/

  rm -rf ~/Downloads/obsidian
  rm -f $XDG_DATA_HOME/applications/obsidian.desktop
}

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

