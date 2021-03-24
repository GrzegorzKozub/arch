#!/usr/bin/env zsh

set -e -o verbose

# video

sudo pacman -S --noconfirm \
  obs-studio shotcut

. ~/code/dotfiles/video.zsh

