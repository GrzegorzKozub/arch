#!/usr/bin/env bash
set -eo pipefail -ux

# in progress: https://github.com/peteonrails/voxtype/tree/main/docs

# packages

paru -S --aur --noconfirm \
  voxtype-bin

# config

voxtype setup --download

# real time keyboard

paru -S --aur --noconfirm \
  dotool
sudo usermod -aG input $USER
echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf

# gpu acceleration

# sudo pacman -S --noconfirm \
#   cuda
#
# sudo voxtype setup gpu --enable

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# For GPU acceleration, run:
#   sudo voxtype setup gpu --enable
# Parakeet: requires cuda package
#
# 1. Add your user to the 'input' group:
#    sudo usermod -aG input $USER
#
# 2. Log out and back in for group changes to take effect
#
# 3. Download a model (Whisper or Parakeet):
#    voxtype setup model
#
# 4. Start voxtype:
#    systemctl --user enable --now voxtype
#
# Optional: Switch to Parakeet engine (faster, lower memory):
#    voxtype setup parakeet --enable
