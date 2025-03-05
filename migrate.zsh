#!/usr/bin/env zsh

set -o verbose

# rga

sudo pacman -S --noconfirm ripgrep-all

# tmux

for DIR in \
  plugins/tmux-battery \
  plugins/tmux-continuum \
  plugins/tmux-resurrect \
  resurrect
do
  rm -rf $XDG_DATA_HOME/tmux/$DIR
done

$XDG_DATA_HOME/tmux/plugins/tpm/bindings/install_plugins

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

