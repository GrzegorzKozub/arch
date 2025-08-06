#!/usr/bin/env zsh

set -o verbose

# amberol

sudo pacman -S --noconfirm amberol

# python

rm -rf $XDG_CONFIG_HOME/ipython

rm -rf $XDG_CACHE_HOME/pip
rm -rf $XDG_CACHE_HOME/pipx

rm -rf ~/.local/bin
rm -rf ~/.local/include
rm -rf ~/.local/lib

sudo pacman -S --noconfirm python-pipx python-pynvim

pipx install --force \
  awscli-local \
  cfn-lint \
  lastversion \
  tidal-dl-ng

# nvim

# rm -rf $XDG_CACHE_HOME/nvim
# rm -rf $XDG_DATA_HOME/nvim
# rm -rf ~/.local/state/nvim
# nvim \
#   -c 'autocmd User MasonToolsUpdateCompleted quitall' \
#   -c 'autocmd User VeryLazy MasonToolsUpdate'

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

