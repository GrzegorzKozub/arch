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

[[ $HOST =~ ^(player|worker)$ ]] &&
  gnome-shell --version | grep -q 50 &&
  gsettings reset org.gnome.mutter experimental-features

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
