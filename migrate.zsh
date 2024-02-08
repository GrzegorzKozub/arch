#!/usr/bin/env zsh

set -o verbose

# elixir, ruby

sudo pacman -Rs --noconfirm \
  elixir \
  ruby

# rust

sudo pacman -Rs --noconfirm \
  rust

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

