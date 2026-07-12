#!/usr/bin/env bash
set -eo pipefail -ux

# fnm -> mise

yay --noconfirm -Rs fnm-bin || true

rm -rf "$XDG_DATA_HOME"/fnm
rm -rf "$XDG_CACHE_HOME"/npm

sudo pacman -S --noconfirm mise usage
pushd ~/code/dot && ./links.sh && popd
eval "$(mise activate bash)"

mise install

# llama

if [[ $HOST =~ ^(player|worker)$ ]]; then
  sudo pacman -Rs --noconfirm llama-cpp || true
  sudo pacman -Rs --noconfirm llama-cpp-vulkan || true
  "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan-bin.sh
fi

# nvim

pushd ~/code/dot && ./reset.sh nvim && popd

# nvidia

if [[ $HOST =~ ^(player|worker)$ ]] &&
  ! cmp -s "${BASH_SOURCE%/*}"/etc/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia.conf; then
  sudo cp "${BASH_SOURCE%/*}"/etc/modprobe.d/nvidia.conf /etc/modprobe.d
  sudo mkinitcpio -P
fi

# vscode

DIR=/usr/share/code/resources/app/extensions/copilot/node_modules/@github/copilot/sdk/prebuilds/linux-x64
if [[ -d $DIR ]]; then
  sudo chmod 775 "$DIR"
fi

# wireplumber

[[ -d /etc/wireplumber/wireplumber.conf.d ]] || sudo mkdir -p /etc/wireplumber/wireplumber.conf.d
sudo cp "${BASH_SOURCE%/*}"/etc/wireplumber/wireplumber.conf.d/bluez.conf /etc/wireplumber/wireplumber.conf.d
if [[ -f "${BASH_SOURCE%/*}"/home/.config/wireplumber/wireplumber.conf.d/$HOST.conf ]]; then
  [[ -d $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d ]] ||
    mkdir -p "$XDG_CONFIG_HOME"/wireplumber/wireplumber.conf.d
  cp "${BASH_SOURCE%/*}"/home/.config/wireplumber/wireplumber.conf.d/"$HOST".conf \
    "$XDG_CONFIG_HOME"/wireplumber/wireplumber.conf.d/audio.conf
fi

# workaround https://bbs.archlinux.org/viewtopic.php?id=307879

if [[ $(systemctl is-enabled NetworkManager-initrd.service 2> /dev/null) != masked ]]; then
  sudo systemctl mask NetworkManager-initrd.service
  sudo mkinitcpio -P
fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
