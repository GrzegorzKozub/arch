#!/usr/bin/env bash
set -eo pipefail -ux

# cachy

# "${BASH_SOURCE%/*}"/cachy.sh
# "${BASH_SOURCE%/*}"/update.sh

# evolution-data-server (required by gnome-shell-calendar-server since gnome-shell 1:50.1)

pacman -Q evolution-data-server &> /dev/null ||
  sudo pacman -S --noconfirm evolution-data-server

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
