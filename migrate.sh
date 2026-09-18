#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# llama

rm -rf "$XDG_CACHE_HOME"/{huggingface,llama.cpp}

# tmux

rm -rf "$XDG_DATA_HOME"/tmux/plugins/tmux-fzf-links

# zsh

rm -rf "$XDG_CACHE_HOME"/zsh/last-working-dir
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--dirhistory
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--last-working-dir

# zsh-lint

mise install

# one time deep cleanup

"${BASH_SOURCE%/*}"/clean.sh deep

rm -rf "$XDG_CACHE_HOME"/{appstream,cmp}/
rm -rf "$XDG_CONFIG_HOME"/{fsh,github-copilot}/
rm -rf "$XDG_DATA_HOME"/man/
rm -rf "$XDG_STATE_HOME"/{.copilot,pipewire}/

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
