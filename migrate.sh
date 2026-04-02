#!/usr/bin/env bash
set -eo pipefail -ux

# aws

if [[ $HOST == 'worker' ]]; then

  rm -rf ~/.config/aws
  ~/code/keys/aws.sh

fi

# claude

"${BASH_SOURCE%/*}"/data.sh

# gdm

sudo rm -f /var/lib/gdm/seat0/config/monitors.xml

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
