#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  aws-cli-v2

yay --aur --noconfirm --answerdiff=None -S \
  aws-sam-cli-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/aws.sh

# keys

~/code/keys/aws.sh
