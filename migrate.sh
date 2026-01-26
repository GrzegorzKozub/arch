#!/usr/bin/env bash
set -eo pipefail -ux

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

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
