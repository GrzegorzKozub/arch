#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862
# teams bug: https://github.com/IsmaelMartinez/teams-for-linux/issues/2169

# copilot

rm -rf ~/.copilot

# duckdb

sudo pacman -S --noconfirm duckdb

# papirus

[[ $(pacman -Q papirus-icon-theme-git) ]] && paru -Rs --noconfirm papirus-icon-theme-git
[[ $(pacman -Q papirus-icon-theme) ]] || sudo pacman -S --noconfirm papirus-icon-theme

# tidal

uv tool uninstall tidal-dl-ng || true
uv tool install tidal-dl-ng-for-dj

rm -rf ~/.config/tidal_dl_ng
~/code/dot/links.sh

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
