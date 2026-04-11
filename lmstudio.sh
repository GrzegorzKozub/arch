#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  lmstudio-bin

# links

cp /usr/share/applications/lmstudio.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^StartupWMClass=.*$/StartupWMClass=LM-Studio/' \
  "$XDG_DATA_HOME"/applications/lmstudio.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/lmstudio.sh

# daemon (after dotfiles)

curl -fsSL https://lmstudio.ai/install.sh | bash
