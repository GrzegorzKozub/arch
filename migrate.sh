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

# vscode

mkdir -p "$XDG_CONFIG_HOME"/vscode

[[ -d ~/.vscode/extensions ]] &&
  mv ~/.vscode/extensions "$XDG_CONFIG_HOME"/vscode/extensions ||
  true

if [[ -d ~/code/dot/vscode/Code ]]; then
  mv ~/code/dot/vscode/Code ~/code/dot/vscode/user-data
  pushd ~/code/dot/vscode/user-data
  git clean -dfx
  popd
fi

~/code/dot/links.sh

rm -rf ~/.vscode
rm -rf ~/.vscode-shared

rm -rf "$XDG_CONFIG_HOME"/code-flags.conf
rm -rf "$XDG_CONFIG_HOME"/Code

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
