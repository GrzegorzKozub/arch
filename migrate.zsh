#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  gnome-font-viewer \
  nushell \
  zellij

pushd ~/code/dotfiles

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  nushell \
  zellij

popd

code --install-extension asvetliakov.vscode-neovim

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

