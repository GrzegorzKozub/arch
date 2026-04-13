#!/usr/bin/env bash
set -eo pipefail -ux

if [[ $HOST == 'worker' ]]; then

  "${BASH_SOURCE%/*}"/claude.sh

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
