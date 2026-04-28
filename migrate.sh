#!/usr/bin/env bash
set -eo pipefail -ux

# hosts

[[ $HOST == 'worker' ]] && sudo sed -i -e "/.*integrations-stage.apsis.cloud.*/d" /etc/hosts

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
