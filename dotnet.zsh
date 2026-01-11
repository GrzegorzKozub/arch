#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  dotnet-sdk aspnet-runtime

# cleanup

`dirname $0`/packages.sh

# dotfiles

~/code/dot/dotnet.zsh

