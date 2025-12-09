#!/usr/bin/env zsh

set -o verbose

# java

sudo pacman -S --noconfirm jdk21-openjdk
sudo archlinux-java set java-21-openjdk

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

