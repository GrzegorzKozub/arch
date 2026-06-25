#!/usr/bin/env bash
set -eo pipefail -ux

# packages

yay --aur --noconfirm --answerdiff=None -S \
  pinta

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
