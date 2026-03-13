#!/usr/bin/env bash
set -eo pipefail -ux

# docx2txt

sudo pacman -S --noconfirm docx2txt

# worktree

sudo pacman -S --noconfirm worktree

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
