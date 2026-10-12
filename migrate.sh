#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
