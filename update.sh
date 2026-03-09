#!/usr/bin/env bash
set -eo pipefail -ux

# update self

pushd "${BASH_SOURCE%/*}" && git pull && popd

# update all packages

# sudo pacman --noconfirm -Sy archlinux-keyring
sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

set +e

paru -S --aur --noconfirm \
  neovim-nightly-bin \
  yazi-nightly-bin

set -e

[[ $HOST =~ ^(player|worker)$ ]] && "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan.sh
[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/claude.sh update

# merge *.pacnew and *.pacsave files

sudo DIFFPROG='nvim -d' pacdiff

# settings

"${BASH_SOURCE%/*}"/settings.sh
"${BASH_SOURCE%/*}"/links.sh

"${BASH_SOURCE%/*}"/gdm.sh

[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && "${BASH_SOURCE%/*}"/gnome.sh

"${BASH_SOURCE%/*}"/mime.sh
"${BASH_SOURCE%/*}"/secrets.sh

# cleanup

sudo journalctl --vacuum-time=1months

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
