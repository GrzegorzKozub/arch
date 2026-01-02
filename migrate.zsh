#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# intel chipset

[[ $HOST == 'drifter' ]] &&
  sudo cp $(dirname $0)/etc/modprobe.d/intel.conf /etc/modprobe.d

# fetch

sudo pacman -S --noconfirm python-requests

# work

if [[ $HOST =~ ^(drifter|worker)$ ]]; then

  rm -rf ~/.config/aws

  pushd ~/code/dot
  git update-index --no-assume-unchanged maven/maven/settings.xml
  popd

  sed -ie '/.*msteams.*/d' ~/.config/mimeapps.list

fi

if [[ $HOST == 'drifter' ]]; then

  # ansible

  sudo pacman -Rs --noconfirm \
    ansible-core ansible \
    python-boto3

  rm -rf ~/.config/ansible

  # aws

  sudo pacman -Rs --noconfirm \
    aws-cli-v2

  paru -Rs --aur --noconfirm \
    aws-sam-cli-bin

  for TOOL in awscli-local cfn-lint; do uv tool uninstall $TOOL; done

  set e+
  code --uninstall-extension kddejong.vscode-cfn-lint --force
  set e-

  # dotnet

  sudo pacman -Rs --noconfirm \
    dotnet-sdk aspnet-runtime

  set e+

  for EXTENSION in \
    ms-dotnettools.csdevkit \
    ms-dotnettools.csharp \
    ms-dotnettools.vscode-dotnet-runtime
  do
    code --uninstall-extension $EXTENSION --force
  done

  set e-

  rm -rf ~/.dotnet
  rm -rf ~/.cache/Microsoft

  # java

  set e+
  sudo archlinux-java unset
  set e-

  sudo pacman -Rs --noconfirm \
    jdk-openjdk jdk21-openjdk maven

  set e+

  for EXTENSION in \
    redhat.java \
    redhat.vscode-yaml
  do
    code --uninstall-extension $EXTENSION --force
  done

  set e-

  rm -rf ~/.cache/maven
  rm -rf ~/.config/maven

  # postman

  paru -Rs --aur --noconfirm \
    postman-bin

  rm -rf $XDG_DATA_HOME/applications/postman.desktop
  rm -rf ~/Postman
  rm -rf ~/.config/Postman

  # vscode

  set e+

  for EXTENSION in \
    bierner.markdown-mermaid \
    cucumberopen.cucumber-official
  do
    code --uninstall-extension $EXTENSION --force
  done

fi

if [[ $HOST == 'worker' ]]; then

  . ~/code/dot/aws.zsh

  systemctl --user disable iam.service
  rm -rf ~/.config/systemd/user/iam.service

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

