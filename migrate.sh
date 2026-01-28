#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# jack

set +e
yes | sudo pacman -S pipewire-jack
set -e

# wireplumber

# ...

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
