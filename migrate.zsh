#!/usr/bin/env zsh

set -o verbose

# rga

sudo pacman -S --noconfirm ripgrep-all

# tmux

rm -rf $XDG_DATA_HOME/tmux/plugins/tmux-battery
rm -rf $XDG_DATA_HOME/tmux/resurrect/*

$XDG_DATA_HOME/tmux/plugins/tpm/bindings/install_plugins

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

