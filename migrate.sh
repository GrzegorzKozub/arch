#!/usr/bin/env bash
set -eo pipefail -ux

# pacman -> yay

"${BASH_SOURCE%/*}"/yay.sh
pushd ~/code/dot && ./links.sh && popd

yay --aur --noconfirm -Rs paru || true
rm -rf ~/.cache/paru
rm -rf ~/.local/state/paru

yay --aur --noconfirm --answerdiff=None -S tmux-git

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
