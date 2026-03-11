#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862
# teams bug: https://github.com/IsmaelMartinez/teams-for-linux/issues/2169

# worktree

sudo pacman -S --noconfirm worktree

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
