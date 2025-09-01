#!/usr/bin/env zsh

set -o verbose

# gemini

npm install --global @google/gemini-cli

# zed

sudo pacman -S --noconfirm prettier shfmt
pipx install --force black isort

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

