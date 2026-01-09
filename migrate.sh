#!/usr/bin/env bash

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# hosts

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/hosts.zsh

# cleanup

"${BASH_SOURCE%/*}"/packages.zsh
"${BASH_SOURCE%/*}"/clean.zsh
