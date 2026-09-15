#!/usr/bin/env bash
set -eo pipefail -ux

# packages

yay --aur --noconfirm --answerdiff=None -S \
  intellij-idea-community-edition-bin # pulls jdk-openjdk even though jdk is now mise managed

# links

cp /usr/share/applications/intellij-idea-community.desktop "$XDG_DATA_HOME"/applications
sed -i -e 's/^Name=.*/Name=IntelliJ/' "$XDG_DATA_HOME"/applications/intellij-idea-community.desktop

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/intellij.sh
