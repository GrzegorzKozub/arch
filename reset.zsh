#!/usr/bin/env zsh

set -o verbose

# nvim

rm -rf $XDG_CACHE_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim
rm -rf ~/.local/state/nvim
nvim \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' \
  -c 'autocmd User VeryLazy MasonToolsUpdate'

