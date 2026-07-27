#!/usr/bin/env bash
set -eo pipefail -ux

# brightness

if [[ $HOST == 'drifter' ]]; then

  sudo systemctl disable brightness.service
  sudo rm -f /etc/systemd/system/brightness.service

  systemctl --user disable brightness.service
  rm -f "$XDG_CONFIG_HOME"/systemd/user/brightness.service

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
