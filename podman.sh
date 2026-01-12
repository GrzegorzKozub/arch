#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  podman

  # podman-compose (if docker-compose is not installed), podman-docker

# kernel.unprivileged_userns_clone=1 is provided via  docker-rootless-extras
# also remove the current setup
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

# to be continued
# https://wiki.archlinux.org/title/Podman
# https://github.com/containers/podman/tree/main/docs/tutorials
