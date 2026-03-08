#!/usr/bin/env bash
set -eo pipefail -ux

TMP="$(mktemp -d)"
trap 'rm -rf $TMP' EXIT

git clone https://aur.archlinux.org/paru.git "$TMP"

pushd "$TMP"

# shellcheck disable=SC2034
CARGO_HOME=

makepkg -si --noconfirm

popd

rm -rf ~/.cargo

sudo pacman -Rs --noconfirm \
  rust
