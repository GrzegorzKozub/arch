#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# data

"${BASH_SOURCE%/*}"/data.sh

# llama

"${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan.sh

CACHE=/run/media/$USER/data/.cache

[[ -d $CACHE/llama.cpp ]] || mkdir "$CACHE"/llama.cpp
[[ -e $XDG_CACHE_HOME/llama.cpp ]] && rm -rf "$XDG_CACHE_HOME"/llama.cpp
ln -s "$CACHE"/llama.cpp "$XDG_CACHE_HOME"/llama.cpp

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
