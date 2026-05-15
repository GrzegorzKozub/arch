#!/usr/bin/env bash
set -eo pipefail -ux

# cachyos repos - https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install

TMP="$(mktemp -d)"
trap 'rm -rf $TMP' EXIT
pushd "$TMP"

curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
yes | sudo ./cachyos-repo.sh || true # ignore 404s and pacman -Syu later, after cachyos-rate-mirrors

popd

# cachyos-rate-mirrors - https://wiki.cachyos.org/cachyos_basic/why_cachyos/#cachyos-custom-applications

sudo pacman -S --noconfirm cachyos-rate-mirrors
sudo cachyos-rate-mirrors
sudo pacman -Syu --noconfirm
