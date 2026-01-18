#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  docker \
  docker-buildx \
  docker-compose

paru -S --aur --noconfirm \
  docker-credential-pass-bin \
  docker-scout

# rootless

paru -S --aur --noconfirm \
  docker-rootless-extras

sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

[[ -d /etc/systemd/system/user@.service.d ]] || sudo mkdir -p /etc/systemd/system/user@.service.d
sudo cp "${BASH_SOURCE%/*}"/etc/systemd/system/user@.service.d/delegate.conf /etc/systemd/system/user@.service.d

systemctl --user enable --now docker.socket

# native overlay diff engine

echo 'options overlay metacopy=off redirect_dir=off' |
  sudo tee /etc/modprobe.d/disable-overlay-redirect-dir.conf > /dev/null

# login

PAT=/run/media/$USER/data/.secrets/docker.secret
[[ -f $PAT ]] && cat "$PAT" | docker login --username grzegorzkozub --password-stdin
