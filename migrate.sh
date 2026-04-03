#!/usr/bin/env bash
set -eo pipefail -ux

[[ $HOST == 'worker' ]] && ~/code/dot/claude.sh

# gdm

sudo rm -f /var/lib/gdm/seat0/config/monitors.xml

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
