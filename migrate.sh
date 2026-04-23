#!/usr/bin/env bash
set -eo pipefail -ux

# nvim

rm -rf "$XDG_DATA_HOME"/applications/nvim.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
