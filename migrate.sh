#!/usr/bin/env bash
set -eo pipefail -ux

# llama

if [[ $HOST =~ ^(player|worker)$ ]]; then
  sudo pacman -Rs --noconfirm llama-cpp-vulkan || true
  sudo pacman -S --noconfirm llama-cpp-vulkan
fi

# workaround https://bbs.archlinux.org/viewtopic.php?id=307879

if [[ $(systemctl is-enabled NetworkManager-initrd.service 2> /dev/null) != masked ]]; then
  sudo systemctl mask NetworkManager-initrd.service
  sudo mkinitcpio -P
fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
