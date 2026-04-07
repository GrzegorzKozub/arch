#!/usr/bin/env bash
set -eo pipefail -ux

# nvim

sudo pacman -S --noconfirm tree-sitter-cli
~/code/dot/reset.sh nvim

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
