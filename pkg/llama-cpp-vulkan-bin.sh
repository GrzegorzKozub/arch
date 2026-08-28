#!/usr/bin/env bash
set -eo pipefail -ux

pushd "${BASH_SOURCE%/*}"/llama-cpp-vulkan-bin

# shellcheck disable=SC1091
AVAILABLE=$(source PKGBUILD && pkgver)
INSTALLED=$(pacman -Q llama-cpp-vulkan-bin 2> /dev/null | awk '{print $2}' | cut -d- -f1)

if [[ $AVAILABLE != "$INSTALLED" ]]; then

  makepkg --force --install --noconfirm --syncdeps
  git clean -dfX
  git checkout PKGBUILD

fi

popd
