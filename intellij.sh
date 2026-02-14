#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  intellij-idea-community-edition-bin

# links

cp /usr/share/applications/intellij-idea-community-edition.desktop "$XDG_DATA_HOME"/applications
sed -i -e 's/^Name=.*/Name=IntelliJ/' "$XDG_DATA_HOME"/applications/intellij-idea-community-edition.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/intellij.sh
