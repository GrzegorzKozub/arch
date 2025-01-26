#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  docker \
  docker-buildx \
  docker-compose

paru -S --aur --noconfirm \
  docker-credential-pass-bin

# native overlay diff

echo 'options overlay metacopy=off redirect_dir=off' | \
  sudo tee /etc/modprobe.d/disable-overlay-redirect-dir.conf > \
  /dev/null

# service as root

# sudo usermod -aG docker $USER # non-root user cli access

# sudo systemctl enable docker.service
# sudo systemctl start docker.service

# rootless

paru -S --aur --noconfirm \
  docker-rootless-extras

for FILE in subuid subgid; do
  echo "$USER:231072:65536" | \
    sudo tee /etc/$FILE > /dev/null
done

DIR=/etc/systemd/system/user@.service.d
[[ -d $DIR ]] || sudo mkdir -p $DIR

echo '[Service]\nDelegate=cpu cpuset io memory pids' | \
  sudo tee $DIR/delegate.conf > /dev/null

# systemctl --user enable docker.service
# systemctl --user start docker.service

systemctl --user enable docker.socket
systemctl --user start docker.socket

