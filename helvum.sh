#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  helvum

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
