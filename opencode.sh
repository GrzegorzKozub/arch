#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  opencode-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/opencode.sh
