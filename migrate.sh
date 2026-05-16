#!/usr/bin/env bash
set -eo pipefail -ux

# paru

if pacman -Q paru-git-debug &> /dev/null; then
  sudo pacman -Rs --noconfirm paru-git-debug
  "${BASH_SOURCE%/*}"/paru.sh
fi

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
