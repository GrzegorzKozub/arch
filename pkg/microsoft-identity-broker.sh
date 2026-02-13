#!/usr/bin/env bash
set -eo pipefail -ux

pushd "${BASH_SOURCE%/*}"/microsoft-identity-broker

makepkg --force --install --noconfirm --syncdeps
git clean -dfX

popd
