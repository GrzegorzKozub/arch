#!/usr/bin/env bash
set -eo pipefail -ux

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# coredump

sudo rm -f /etc/tmpfiles.d/coredump.conf

# docker & podman

sudo sed -i '/231072/d' /etc/subgid /etc/subuid
# sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

"${BASH_SOURCE%/*}"/podman.sh

# hosts

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/hosts.zsh

# laptop power saving

[[ $HOST == 'drifter' ]] && {
  sudo rm -rf /etc/sysctl.d/dirty.conf /etc/modprobe.d/iwlwifi.conf
  sudo cp "${BASH_SOURCE%/*}"/etc/modprobe.d/laptop.conf /etc/modprobe.d
  sudo cp "${BASH_SOURCE%/*}"/etc/sysctl.d/80-laptop.conf /etc/sysctl.d
}

# limine

sudo rm -f /etc/pacman.d/hooks/90-limine-update.hook
sudo cp "${BASH_SOURCE%/*}"/etc/pacman.d/hooks/91-limine.hook /etc/pacman.d/hooks/

# vscode

code --install-extension ms-vscode-remote.remote-containers --force

# webcam

sudo rm -rf /etc/udev/rules.d/*c922*.rules

SOURCE="${BASH_SOURCE%/*}"/etc/udev/rules.d/90-webcam.$HOST.rules
[[ -f $SOURCE ]] && sudo cp "$SOURCE" /etc/udev/rules.d/90-webcam.rules

# jan 25th

# jack

set +e
yes | sudo pacman -S pipewire-jack
set -e

# noise-suppression-for-voice

[[ $HOST == 'worker' ]] && {
  sudo pacman -S --noconfirm noise-suppression-for-voice
  sudo cp "${BASH_SOURCE%/*}"/home/"$USER"/.config/pipewire/pipewire.conf.d/99-rnnoise.conf "$XDG_CONFIG_HOME"/pipewire/pipewire.conf.d
}

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
