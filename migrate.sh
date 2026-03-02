#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# state home

rm -rf ~/.copilot

# papirus

[[ $(pacman -Q papirus-icon-theme-git) ]] && paru -Rs --noconfirm papirus-icon-theme-git
[[ $(pacman -Q papirus-icon-theme) ]] || sudo pacman -S --noconfirm papirus-icon-theme

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
