#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# fetch

sudo pacman -S --noconfirm python-requests

# aws

if [[ $HOST =~ ^(drifter|worker)$ ]]; then

  rm -rf ~/.config/aws
  . ~/code/dot/aws.zsh

fi

if [[ $HOST == 'worker' ]]; then

  systemctl --user disable iam.service
  rm -rf ~/.config/systemd/user/iam.service

fi

# java

if [[ $HOST =~ ^(drifter|worker)$ ]]; then

  pushd ~/code/dot
  git update-index --no-assume-unchanged maven/maven/settings.xml
  popd

fi

# teams

[[ $HOST =~ ^(drifter|worker)$ ]] &&
  sed -ie '/.*msteams.*/d' ~/.config/mimeapps.list

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

