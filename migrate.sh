#!/usr/bin/env bash
set -eo pipefail -ux

# worktree

sudo pacman -S --noconfirm worktree

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
