#!/usr/bin/env bash
set -eo pipefail -ux

# update only

[[ ${1:-} == 'update' ]] && {
  claude --update
  find "$XDG_DATA_HOME"/claude/versions -mindepth 1 |
    sort --numeric-sort --reverse |
    tail --lines=+2 |
    xargs --no-run-if-empty rm
  exit
}

# packages

curl -fsSL https://claude.ai/install.sh | bash
rm -rf ~/.claude

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/claude.sh
