#!/usr/bin/env zsh

set -o verbose

# migrate

paru -S --aur --noconfirm \
  gnome-shell-extension-rounded-window-corners-reborn

rm -rf ~/.cache/npm

fnm uninstall 22
fnm install --latest
fnm use default

npm install --global \
  autocannon \
  eslint \
  neovim \
  typescript

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

