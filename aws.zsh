#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  aws-cli-v2

paru -S --aur --noconfirm \
  aws-sam-cli-bin

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/aws.zsh

