#!/usr/bin/env bash
set -eo pipefail -ux

# prep

pushd "${BASH_SOURCE%/*}" && git pull && popd
pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# vm

[[ -d /run/media/$USER/data/vm ]] && find /run/media/"$USER"/data/vm -mindepth 1 -delete

# yazi

ya pkg add yazi-rs/plugins:compress

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
