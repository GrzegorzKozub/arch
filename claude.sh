#!/usr/bin/env bash
set -eo pipefail -ux

# update only

[[ ${1:-} == 'update' ]] && {
  claude --update
  # cd ~/.local/share/claude/versions
  # find . -maxdepth 1 -mindepth 1 -printf '%T@ %p\n' | sort -rn | tail -n +2 | cut -d' ' -f2- | xargs -r rm
  exit
}

# packages

curl -fsSL https://claude.ai/install.sh | bash
rm -rf ~/.claude

sudo pacman -S --noconfirm \
  socat

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/claude.sh
