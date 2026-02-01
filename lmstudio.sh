#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  lmstudio-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/lmstudio.sh
