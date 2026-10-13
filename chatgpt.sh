#!/usr/bin/env bash
set -eo pipefail -ux

# install via https://learn.chatgpt.com/docs/linux/linux-app#install-on-arch-linux

TMP=$(mktemp --directory)
trap 'rm -rf "$TMP"' EXIT

curl --proto '=https' --tlsv1.2 -fL -o "$TMP"/install-arch.sh \
  https://persistent.oaistatic.com/codex-app-prod/linux/install-arch.sh

sudo bash "$TMP"/install-arch.sh

# links

cp /usr/share/applications/chatgpt.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e "s|^Exec=chatgpt|Exec=env CODEX_HOME=$XDG_CONFIG_HOME/codex chatgpt|" \
  "$XDG_DATA_HOME"/applications/chatgpt.desktop
