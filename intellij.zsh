#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  intellij-idea-community-edition-bin

# links

cp /usr/share/applications/intellij-idea-community-edition.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=IntelliJ/' $XDG_DATA_HOME/applications/intellij-idea-community-edition.desktop

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/intellij.zsh

