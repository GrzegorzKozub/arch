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

# zsh

rm -rf ~/.cache/zsh/last-working-dir
rm -rf ~/.local/share/zi/snippets/OMZ::plugins--dirhistory
rm -rf ~/.local/share/zi/snippets/OMZ::plugins--last-working-dir

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
