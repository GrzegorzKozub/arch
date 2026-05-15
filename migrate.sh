#!/usr/bin/env bash
set -eo pipefail -ux

# paru

# "${BASH_SOURCE%/*}"/paru.sh
pacman -Q paru-git-debug &> /dev/null &&
  sudo pacman -Rs --noconfirm paru-git-debug

# tiddl

pushd ~/code/dot
./reset.sh python
./links.sh
popd

rm -rf ~/.config/tidal_dl_ng-dev

# yazi

ya pkg add yazi-rs/plugins:toggle-pane || true

# zed

pacman -Q gnu-netcat &> /dev/null &&
  sudo pacman -R --noconfirm gnu-netcat &&
  sudo pacman -S --noconfirm openbsd-netcat || true

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
