#!/usr/bin/env zsh

set -o verbose

# ghostty

sudo pacman -S --noconfirm ghostty

# nvim

rm -rf $XDG_CACHE_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim
rm -rf ~/.local/state/nvim

nvim \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' \
  -c 'autocmd User VeryLazy MasonToolsUpdate'

# vconsole

[[ $HOST = 'player' ]] &&
  sudo sed -i -e 's/216b/232b/' /etc/vconsole.conf

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

