#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  inkscape

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
