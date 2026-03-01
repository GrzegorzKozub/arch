#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  ansible-core ansible \
  python-boto3

# config

sudo chfn -f "$USER" "$USER" # gecos

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/ansible.sh
