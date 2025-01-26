#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  docker \
  docker-buildx \
  docker-compose

paru -S --aur --noconfirm \
  docker-credential-pass-bin

# non-root user cli access

sudo usermod -aG docker $USER

# native overlay diff

echo 'options overlay metacopy=off redirect_dir=off' | \
  sudo tee /etc/modprobe.d/disable-overlay-redirect-dir.conf > \
  /dev/null

# service

sudo systemctl enable docker.service
sudo systemctl start docker.service

