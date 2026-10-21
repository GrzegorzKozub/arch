#!/usr/bin/env bash
set -eo pipefail -ux

# lsp

sudo pacman -S --noconfirm lua-language-server

# dotfiles

~/code/dot/claude.sh
