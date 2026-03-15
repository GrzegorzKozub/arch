#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  pinta

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
