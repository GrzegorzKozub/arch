#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  podman

  # podman-docker

[[ $(pacman -Qqs docker-compose) ]] ||
  sudo pacman -S --noconfirm \
    podman-compose

# rootless

# also set via /usr/lib/sysctl.d/99-docker-rootless.conf from docker-rootless-extras
sudo cp "${BASH_SOURCE%/*}"/etc/sysctl.d/99-podman-rootless.conf /etc/sysctl.d

sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"
podman system migrate

# foreign architectures

# sudo pacman -S --noconfirm \
#   qemu-user-static \
#   qemu-user-static-binfmt

# automatically restart containers with restart policy

# systemctl --user enable podman-restart.service

# login

# PAT=/run/media/$USER/data/.secrets/docker.secret
#
# [[ -f $PAT ]] &&
#   for REGISTRY in docker.io registry-1.docker.io; do
#     cat "$PAT" | podman login --username grzegorzkozub --password-stdin $REGISTRY
#   done

# to be continued
# https://wiki.archlinux.org/title/Podman#Docker_Compose
# https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
