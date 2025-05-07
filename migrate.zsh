#!/usr/bin/env zsh

set -o verbose

# btop

pushd ~/code/dot
git update-index --assume-unchanged btop/btop/btop.conf
popd

# nvim

rm -rf $XDG_CACHE_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim
rm -rf ~/.local/state/nvim

nvim \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' \
  -c 'autocmd User VeryLazy MasonToolsUpdate'

# obsidian

pushd ~/code/dot && git pull && popd

[[ -f $XDG_CONFIG_HOME/obsidian/user-flags.conf ]] || {

  mv $XDG_CONFIG_HOME/obsidian ~/Downloads

  pushd ~/code/dot
  stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow obsidian
  popd

  mv ~/Downloads/obsidian/* $XDG_CONFIG_HOME/obsidian/

  rm -rf ~/Downloads/obsidian
  rm -f $XDG_DATA_HOME/applications/obsidian.desktop
}

# pastel

sudo pacman -S --noconfirm pastel

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

