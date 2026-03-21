#!/usr/bin/env bash
set -eo pipefail -ux

# docx2txt

sudo pacman -S --noconfirm docx2txt

# github

"${BASH_SOURCE%/*}"/data.sh
"${BASH_SOURCE%/*}"/secrets.sh

# tidal

pushd ~/code/dot
git update-index --assume-unchanged tidal-hifi/tidal-hifi/config.json
popd

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
