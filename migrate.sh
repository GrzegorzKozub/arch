#!/usr/bin/env bash
set -eo pipefail -ux

# laptop screen brightness

if [[ $HOST == 'drifter' ]]; then

  sudo cp "${BASH_SOURCE%/*}"/etc/systemd/system/brightness.service /etc/systemd/system/
  sudo systemctl enable brightness.service

  cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/brightness.service "$XDG_CONFIG_HOME"/systemd/user/
  systemctl --user enable brightness.service

fi

# hosts

[[ $HOST == 'worker' ]] && sudo sed -i -e "/.*integrations-stage.apsis.cloud.*/d" /etc/hosts

# mime

sed -ie '/Postman/d' ~/.config/mimeapps.list
rm -rf ~/.config/mimeapps.liste

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
