#!/usr/bin/env bash
set -eo pipefail -ux

TMP="$(mktemp -d)"
trap 'rm -rf $TMP' EXIT

git clone https://aur.archlinux.org/yay-bin.git "$TMP"

pushd "$TMP"

makepkg -si --noconfirm

popd
