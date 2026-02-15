#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  aws-cli-v2

paru -S --aur --noconfirm \
  aws-sam-cli-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/aws.sh
