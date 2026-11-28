#!/usr/bin/env bash
set -eo pipefail -ux

# update self

pushd "${BASH_SOURCE%/*}" && git pull && popd
[[ ${PULLED:-} ]] || PULLED=1 exec "$BASH" "$0" "$@"
unset PULLED

# prep

pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# TODO: undo on worker
# cachyos-v3 ships stale nvidia-open 620.70.06-0 that requires missing nvidia-utils 620.70.06
# sudo pacman --noconfirm --needed -Su cachyos-extra-v3/nvidia-open

# tiddl

uv tool install --force git+https://github.com/GrzegorzKozub/tiddl

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
