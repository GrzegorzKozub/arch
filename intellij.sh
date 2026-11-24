#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  intellij-idea-oss # pulls jdk21-openjdk even though jdk is now mise managed

# links

cp /usr/share/applications/idea.desktop "$XDG_DATA_HOME"/applications
sed -i -e 's/^Name=.*/Name=IntelliJ/' "$XDG_DATA_HOME"/applications/idea.desktop

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/intellij.sh
