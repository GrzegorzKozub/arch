#!/usr/bin/env bash
set -eo pipefail -ux

# llama

if [[ $HOST =~ ^(player|worker)$ ]]; then
  sudo pacman -Rs llama-cpp-vulkan || true
  sudo pacman -S --noconfirm llama-cpp
fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
