#!/usr/bin/env bash
set -eo pipefail -ux

# work

[[ $HOST == 'worker' ]] && mkdir -p ~/code/apsis

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
