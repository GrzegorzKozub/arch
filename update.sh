#!/usr/bin/env bash
set -eo pipefail -ux

# update self

pushd "${BASH_SOURCE%/*}" && git pull && popd

# update all packages

GNOME_SHELL_VERSION=$(pacman -Q gnome-shell | awk '{print $2}')

# sudo pacman --noconfirm -Sy archlinux-keyring
sudo pacman --noconfirm -Syu
yay --aur --noconfirm --answerdiff=None -Syu

if [[ $(pacman -Q gnome-shell | awk '{print $2}') != "$GNOME_SHELL_VERSION" ]]; then
  export GNOME_SHELL_UPGRADED=1
else
  export GNOME_SHELL_UPGRADED=0
fi

[[ $HOST =~ ^(player|worker)$ ]] && "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan-bin.sh
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
