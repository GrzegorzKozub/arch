#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  claude-code

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/claude.zsh

