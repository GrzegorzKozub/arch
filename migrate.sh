#!/usr/bin/env bash
set -eo pipefail -ux

# hosts

[[ $HOST == 'worker' ]] && sudo sed -i -e "/.*integrations-stage.apsis.cloud.*/d" /etc/hosts

# laptop screen brightness

if [[ $HOST == 'drifter' ]]; then

  sudo cp "${BASH_SOURCE%/*}"/etc/systemd/system/brightness.service /etc/systemd/system/
  sudo systemctl enable brightness.service

  cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/brightness.service "$XDG_CONFIG_HOME"/systemd/user/
  systemctl --user enable brightness.service

fi

# mime

sed -ie '/Postman/d' ~/.config/mimeapps.list
rm -rf ~/.config/mimeapps.liste

#❗vscode --extensions-dir & --shared-data-dir

mkdir -p "$XDG_DATA_HOME"/Code
[[ -d ~/.vscode/extensions ]] &&
  mv ~/.vscode/extensions "$XDG_DATA_HOME"/Code/extensions ||
  true
rm -rf ~/.vscode
rm -rf ~/.vscode-shared

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
