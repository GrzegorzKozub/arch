#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# claude

if [[ $HOST == 'worker' ]]; then
  pushd ~/code/dot
  ln -sf ~/code/dot/claude/claude/keybindings.json \
    "$XDG_CONFIG_HOME"/claude/keybindings.json
  popd
fi

# dotnet

if [[ $HOST == 'worker' ]]; then
  sudo pacman -Rs --noconfirm dotnet-sdk aspnet-runtime
  ln -sf "$XDG_CONFIG_HOME"/mise/conf.d/dotnet.env.toml \
    "$XDG_CONFIG_HOME"/mise/conf.d/dotnet."$HOST".local.toml
  ln -sf "$XDG_CONFIG_HOME"/mise/conf.d/csharp-ls.env.toml \
    "$XDG_CONFIG_HOME"/mise/conf.d/csharp-ls."$HOST".local.toml
  mise install
fi

# zsh

rm -rf ~/.cache/zsh/last-working-dir
rm -rf ~/.local/share/zi/snippets/OMZ::plugins--dirhistory
rm -rf ~/.local/share/zi/snippets/OMZ::plugins--last-working-dir

# zsh-lint

mise install

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
