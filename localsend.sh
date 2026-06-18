#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur \
  localsend-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/localsend.sh
