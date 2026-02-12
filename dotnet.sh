#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  dotnet-sdk aspnet-runtime

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/dotnet.sh
