#!/usr/bin/env bash
set -eo pipefail -ux

# llama

if [[ $HOST =~ ^(player|worker)$ ]]; then
  sudo pacman -Rs --noconfirm llama-cpp || true
  sudo pacman -Rs --noconfirm llama-cpp-vulkan || true
  "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan-bin.sh
fi

# vscode

DIR=/usr/share/code/resources/app/extensions/copilot/node_modules/@github/copilot/sdk/prebuilds/linux-x64
if [[ -d $DIR ]]; then
  sudo chmod 775 "$DIR"
fi

# wireplumber

[[ -d $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d ]] || mkdir -p "$XDG_CONFIG_HOME"/wireplumber/wireplumber.conf.d
cp "${BASH_SOURCE%/*}"/home/.config/wireplumber/wireplumber.conf.d/disable-bluez-midi.conf "$XDG_CONFIG_HOME"/wireplumber/wireplumber.conf.d

# workaround https://bbs.archlinux.org/viewtopic.php?id=307879

if [[ $(systemctl is-enabled NetworkManager-initrd.service 2> /dev/null) != masked ]]; then
  sudo systemctl mask NetworkManager-initrd.service
  sudo mkinitcpio -P
fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
