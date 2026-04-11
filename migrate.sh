#!/usr/bin/env bash
set -eo pipefail -ux

if [[ $HOST == 'worker' ]]; then

  # nvim

  sudo pacman -S --noconfirm tree-sitter-cli
  ~/code/dot/reset.sh nvim

  # wget

  rm -rf ~/.cache/wget-hsts

fi

# gnome

if gnome-shell --version | grep -q 50; then

  gsettings reset org.gnome.mutter experimental-features
  gnome-extensions disable rounded-window-corners@fxgn

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
