#!/usr/bin/env zsh

set -e -o verbose

# remove obsolete dirs and files

[[ -f ~/.zshrc ]] && rm -f ~/.zshrc

[[ -d ~/.gnome ]] && rm -rf ~/.gnome

# [[ -d ~/.cache/js-v8flags ]] && rm -rf ~/.cache/js-v8flags
# [[ -d ~/.cache/yarn ]] && rm -rf ~/.cache/yarn
# [[ -f ~/.yarnrc ]] && rm ~/.yarnrc

