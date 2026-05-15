#!/usr/bin/env bash
set -eo pipefail -ux

# cachyos repos - https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install

TMP="$(mktemp -d)"
trap 'rm -rf $TMP' EXIT
pushd "$TMP"

curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
yes | sudo ./cachyos-repo.sh

popd

pacman -Syu --noconfirm
