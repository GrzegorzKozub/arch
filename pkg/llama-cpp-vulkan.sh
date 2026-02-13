#!/usr/bin/env bash
set -eo pipefail -ux

pushd "${BASH_SOURCE%/*}"/llama-cpp-vulkan

makepkg --force --install --noconfirm --syncdeps
git clean -dfX

popd
