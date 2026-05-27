#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  niri

# dotfiles

~/code/dot/niri.sh
