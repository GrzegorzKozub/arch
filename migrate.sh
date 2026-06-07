#!/usr/bin/env bash
set -eo pipefail -ux

# playerctl

sudo pacman -S --noconfirm playerctl

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
