#!/usr/bin/env bash
set -eo pipefail -ux

# update only

# [[ ${1:-} == 'update' ]] && {
#   claude --update
#   find "$XDG_DATA_HOME"/claude/versions -mindepth 1 -maxdepth 1 |
#     sort --reverse --version-sort |
#     tail --lines=+2 |
#     xargs --no-run-if-empty rm
#   exit
# }

# install

# curl -fsSL https://claude.ai/install.sh | bash
# rm -rf ~/.claude

ln -sf "$XDG_CONFIG_HOME"/mise/conf.d/claude.env.toml \
  "$XDG_CONFIG_HOME"/mise/conf.d/claude."$HOST".local.toml

mise install

# lsp

sudo pacman -S --noconfirm lua-language-server

# dotfiles

~/code/dot/claude.sh
