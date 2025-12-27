#!/usr/bin/env zsh

set -e -o verbose

# packages

curl -fsSL https://claude.ai/install.sh | bash

sudo pacman -S --noconfirm \
  socat

# dotfiles

. ~/code/dot/claude.zsh

