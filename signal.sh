#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  signal-desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
