#!/usr/bin/env bash
set -eo pipefail -ux

pushd "${BASH_SOURCE%/*}"/llama-cpp-vulkan-bin

makepkg --force --install --noconfirm --syncdeps
git clean -dfX
git checkout PKGBUILD

popd
