#!/usr/bin/env zsh

set -e -o verbose

# packages

curl -fsSL https://claude.ai/install.sh | bash

# dotfiles

. ~/code/dot/claude.zsh

