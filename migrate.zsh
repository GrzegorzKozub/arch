#!/usr/bin/env zsh

set -o verbose

# github

sudo pacman -S --noconfirm github-cli

# iam

if [[ $HOST == 'drifter' ]]; then

  systemctl --user disable iam.service || true
  rm -f $XDG_CONFIG_HOME/systemd/user/iam.service

fi

# uv

sudo pacman -Rs --noconfirm python-pipx

rm -rf $XDG_CACHE_HOME/pip
rm -rf $XDG_CACHE_HOME/pipx
rm -rf $XDG_DATA_HOME/pipx
rm -rf ~/.local/bin
rm -rf ~/.local/state/pipx

rm -rf $XDG_CACHE_HOME/uv
rm -rf $XDG_DATA_HOME/uv

for TOOL in lastversion tidal-dl-ng; do
  uv tool install $TOOL; done

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work
  for TOOL in awscli-local cfn-lint; do uv tool install $TOOL; done
fi

# vscode

for EXTENSION in \
  ms-python.black-formatter \
  ms-python.isort \
  ms-python.pylint \
  ms-python.vscode-pylance
do
  code --uninstall-extension $EXTENSION --force
done

for EXTENSION in \
  charliermarsh.ruff \
  detachhead.basedpyright \
do
  code --install-extension $EXTENSION --force
done

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

