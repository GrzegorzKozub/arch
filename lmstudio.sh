#!/usr/bin/env bash
set -eo pipefail -ux

# packages

yay --aur --noconfirm --answerdiff=None -S \
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
