#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  jdk-openjdk jdk21-openjdk maven

# config

sudo archlinux-java set java-21-openjdk

# cleanup

`dirname $0`/packages.zsh

# dotfiles

~/code/dot/java.zsh

