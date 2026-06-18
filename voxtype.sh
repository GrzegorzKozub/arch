#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur \
  voxtype-bin

# type mode

sudo usermod -aG input "$USER"

cargo install eitype # https://github.com/Adam-D-Lewis/eitype

# paru -S --aur \
#   dotool
#
# sudo cp "${BASH_SOURCE%/*}"/etc/modules-load.d/uinput.conf /etc/modules-load.d

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/voxtype.sh

# config

sudo voxtype setup gpu --enable

voxtype setup --download
voxtype setup systemd
