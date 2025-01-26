#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  docker \
  docker-buildx \
  docker-compose

paru -S --aur --noconfirm \
  docker-credential-pass-bin

# grant non-root user cli access

sudo usermod -aG docker $USER

# enable and start the service

sudo systemctl enable docker.service
sudo systemctl start docker.service

