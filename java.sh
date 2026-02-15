#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  jdk-openjdk jdk21-openjdk maven

# config

sudo archlinux-java set java-21-openjdk

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/java.sh
