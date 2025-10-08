#!/usr/bin/env zsh

set -e -o verbose

# packages

[[ $(pacman -Qs jre-openjdk) ]] && sudo pacman -Rs --noconfirm jre-openjdk

sudo pacman -S --noconfirm \
  jdk-openjdk \
  maven

# links

for APP in \
  java-java-openjdk \
  jconsole-java-openjdk \
  jshell-java-openjdk
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/java.zsh

