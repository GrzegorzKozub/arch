#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  pinta

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
