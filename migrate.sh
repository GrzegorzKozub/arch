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

fi

pacman -Q gnome-browser-connector-git &> /dev/null && sudo pacman -Rs --noconfirm gnome-browser-connector-git || true
sudo pacman -S --noconfirm gnome-browser-connector

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
