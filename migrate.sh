#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# claude

if [[ $HOST == 'worker' ]]; then

  pushd ~/code/dot
  ln -sf ~/code/dot/claude/claude/keybindings.json \
    "$XDG_CONFIG_HOME"/claude/keybindings.json
  popd

fi

# dotnet

if [[ $HOST == 'worker' ]]; then

  set e+
  for EXTENSION in \
    ms-dotnettools.csdevkit \
    ms-dotnettools.csharp \
    ms-dotnettools.vscode-dotnet-runtime; do
    code --uninstall-extension $EXTENSION --force
  done
  set e-

  dotnet tool uninstall --global csharp-ls || true
  sudo pacman -Rs --noconfirm dotnet-sdk aspnet-runtime || true

fi

rm -rf "$XDG_CACHE_HOME"/{csdevkit,dotnet,Microsoft,Microsoft\ DevDiv}
rm -rf "$XDG_DATA_HOME"/{dotnet,Microsoft,NuGet}

# java

if [[ $HOST == 'worker' ]]; then

  set e+
  for EXTENSION in \
    redhat.java \
    redhat.vscode-yaml; do
    code --uninstall-extension $EXTENSION --force
  done
  set e-

  rm -rf "$XDG_CACHE_HOME"/maven
  rm -rf "$XDG_CONFIG_HOME"/maven

  rm -rf ~/code/dot/maven/maven/settings.xml

fi

# llama

rm -rf "$XDG_CACHE_HOME"/{huggingface,llama.cpp}

# zsh

rm -rf "$XDG_CACHE_HOME"/zsh/last-working-dir
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--dirhistory
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--last-working-dir

# zsh-lint

mise install

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
