#!/usr/bin/env bash
set -eo pipefail -ux

# llama

if [[ $HOST =~ ^(player|worker)$ ]]; then
  sudo pacman -Rs --noconfirm llama-cpp || true
  sudo pacman -Rs --noconfirm llama-cpp-vulkan || true
  "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan-bin.sh
fi

# workaround https://bbs.archlinux.org/viewtopic.php?id=307879

if [[ $(systemctl is-enabled NetworkManager-initrd.service 2> /dev/null) != masked ]]; then
  sudo systemctl mask NetworkManager-initrd.service
  sudo mkinitcpio -P
fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
