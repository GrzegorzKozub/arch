#!/usr/bin/env bash
set -eo pipefail -ux

# packages

curl -fsSL https://claude.ai/install.sh | bash

sudo pacman -S --noconfirm \
  socat

# dotfiles

~/code/dot/claude.sh
