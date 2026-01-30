#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  terraform

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/terraform.sh
