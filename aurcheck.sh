#!/usr/bin/env bash
set -eo pipefail -ux

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth=1 https://github.com/lenucksi/aur-malware-check.git "$TMP"

pushd "$TMP"

python -m aur_check --full --refresh

popd
