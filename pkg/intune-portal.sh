#!/usr/bin/env bash
set -eo pipefail -ux

pushd "${BASH_SOURCE%/*}"/intune-portal

makepkg --force --install --noconfirm --syncdeps
git clean -dfX

popd
