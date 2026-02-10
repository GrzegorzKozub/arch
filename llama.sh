#!/usr/bin/env bash
set -eo pipefail -ux

# packages

DIR=/tmp/llama
[[ -d $DIR ]] && rm -rf $DIR

git clone git@github.com:GrzegorzKozub/llama.cpp-vulkan-bin.git $DIR

pushd $DIR
makepkg --force --install --noconfirm
popd

rm -rf $DIR

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/llama.sh
