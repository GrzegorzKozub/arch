#!/usr/bin/env bash
set -eo pipefail -ux

# paru

"${BASH_SOURCE%/*}"/paru.sh
sudo pacman -Rs --noconfirm paru-git-debug

# tiddl

pushd ~/code/dot
./reset.sh python
./links.sh
popd

rm -rf ~/.config/tidal_dl_ng-dev

# yazi

ya pkg add yazi-rs/plugins:toggle-pane

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
