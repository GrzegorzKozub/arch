#!/usr/bin/env zsh

set -o verbose

# elixir, ruby

sudo pacman -Rs --noconfirm \
  elixir \
  ruby

# rust

sudo pacman -Rs --noconfirm \
  rust

[[ -d $XDG_DATA_HOME/cargo ]] && rm -rf $XDG_DATA_HOME/cargo
[[ -d $XDG_DATA_HOME/rustup ]] && rm -rf $XDG_DATA_HOME/rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

