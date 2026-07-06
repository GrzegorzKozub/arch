#!/usr/bin/env bash
set -eo pipefail -ux

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
