#!/usr/bin/env bash
set -eo pipefail -ux

# harper-ls

~/code/dot/reset.sh nvim

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
