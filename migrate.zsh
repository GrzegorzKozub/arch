#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# fetch

sudo pacman -S --noconfirm python-requests

# work

if [[ $HOST =~ ^(drifter|worker)$ ]]; then

  rm -rf ~/.config/aws
  . ~/code/dot/aws.zsh

  systemctl --user disable iam.service
  rm -rf ~/.config/systemd/user/iam.service

  pushd ~/code/dot
  git update-index --no-assume-unchanged maven/maven/settings.xml
  popd

  sed -ie '/.*msteams.*/d' ~/.config/mimeapps.list

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

