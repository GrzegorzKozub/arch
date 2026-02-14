#!/usr/bin/env bash
set -eo pipefail -ux

# packages

[[ $(pacman -Qqs jre-openjdk) || $(pacman -Qqs jdk-openjdk) ]] ||
  sudo pacman -S --noconfirm \
    jre-openjdk

sudo pacman -S --noconfirm \
  dbeaver

# config

CFG=/usr/share/dbeaver/dbeaver.ini
OPT=-Dosgi.configuration.area

grep -q $OPT $CFG || {
  echo $OPT=@user.home/.local/share/DBeaver | sudo tee --append $CFG > /dev/null
}

# links

cp /usr/share/applications/io.dbeaver.DBeaver.desktop "$XDG_DATA_HOME"/applications
sed -i -e 's/^Name=.*/Name=DBeaver/' "$XDG_DATA_HOME"/applications/io.dbeaver.DBeaver.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/dbeaver.sh
