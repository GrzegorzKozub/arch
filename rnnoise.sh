#!/usr/bin/env bash
set -eo pipefail -ux

# https://github.com/werman/noise-suppression-for-voice

# packages

sudo pacman -S --noconfirm \
  noise-suppression-for-voice

# config

[[ -d $XDG_CONFIG_HOME/pipewire/pipewire.conf.d ]] || mkdir -p "$XDG_CONFIG_HOME"/pipewire/pipewire.conf.d
cp "${BASH_SOURCE%/*}"/home/"$USER"/.config/pipewire/pipewire.conf.d/99-rnnoise.conf "$XDG_CONFIG_HOME"/pipewire/pipewire.conf.d

# apply

systemctl --user restart pipewire
