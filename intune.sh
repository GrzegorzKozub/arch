#!/usr/bin/env bash
set -eo pipefail -ux

# packages

"${BASH_SOURCE%/*}"/pkg/microsoft-identity-broker.sh
"${BASH_SOURCE%/*}"/pkg/intune-portal.sh

# services

systemctl --user enable --now intune-agent.timer

# links

cp /usr/share/applications/intune-portal.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Name=Microsoft Intune$/Name=Intune/' \
  -e 's/^Exec=env /Exec=env WEBKIT_DISABLE_DMABUF_RENDERER=1 /' \
  "$XDG_DATA_HOME"/applications/intune-portal.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
