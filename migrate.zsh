#!/usr/bin/env zsh

set -o verbose

# bat

bat cache --build

# vscode

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work

  for EXTENSION in \
    github.copilot \
    github.copilot-chat \
    redhat.java
  do
    code --install-extension $EXTENSION --force
  done

fi

# uv

sudo pacman -S --noconfirm uv

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

