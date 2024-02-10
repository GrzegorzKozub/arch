#!/usr/bin/env zsh

set -o verbose

paru -Rs --noconfirm \
  gitflow-avh \
  gitflow-zshcompletion-avh

paru -S --aur --noconfirm \
  golangci-lint-bin

