#!/usr/bin/env bash
set -eo pipefail -ux

# prep

pushd "${BASH_SOURCE%/*}" && git pull && popd
pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# yazi

ya pkg add yazi-rs/plugins:compress

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
