#!/usr/bin/env bash
set -eo pipefail -ux

# packages

"${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan-bin.sh

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# update only

[[ ${1:-} == 'update' ]] && exit

# dotfiles

~/code/dot/llama.sh
