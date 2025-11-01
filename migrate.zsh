#!/usr/bin/env zsh

set -o verbose

# java

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work

  sudo pacman -S --noconfirm jdk-openjdk maven

  pushd ~/code/dot
  git update-index --assume-unchanged maven/maven/settings.xml
  popd

fi

# seahorse

sudo pacman -S --noconfirm seahorse

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

