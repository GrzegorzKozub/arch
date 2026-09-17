#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# ansible

if [[ $HOST == 'worker' ]]; then

  sudo pacman -Rs --noconfirm ansible-core ansible python-boto3 || true

  rm -rf "$XDG_CONFIG_HOME"/ansible

  rm -rf ~/code/dot/ansible/ansible/ansible.secret

fi

# claude

if [[ $HOST == 'worker' ]]; then

  pushd ~/code/dot
  ln -sf ~/code/dot/claude/claude/keybindings.json \
    "$XDG_CONFIG_HOME"/claude/keybindings.json
  popd

  npx --yes skills add mattpocock/skills \
    --agent claude-code --copy --global --yes \
    --skill grill-me \
    --skill grilling \
    --skill handoff

fi

# dotnet

if [[ $HOST == 'worker' ]]; then

  # set e+
  # for EXTENSION in \
  #   ms-dotnettools.csdevkit \
  #   ms-dotnettools.csharp \
  #   ms-dotnettools.vscode-dotnet-runtime; do
  #   code --uninstall-extension $EXTENSION --force || true
  # done
  # set e-

  dotnet tool uninstall --global csharp-ls || true
  sudo pacman -Rs --noconfirm dotnet-sdk aspnet-runtime || true

  rm -rf "$XDG_CACHE_HOME"/{csdevkit,dotnet,Microsoft,Microsoft\ DevDiv}
  rm -rf "$XDG_DATA_HOME"/{dotnet,Microsoft,NuGet}

fi

# java

if [[ $HOST == 'worker' ]]; then

  # set e+
  # for EXTENSION in \
  #   redhat.java \
  #   redhat.vscode-yaml; do
  #   code --uninstall-extension $EXTENSION --force || true
  # done
  # set e-

  sudo pacman -Rs --noconfirm jdk-openjdk jdk21-openjdk maven || true

  rm -rf "$XDG_CACHE_HOME"/maven
  rm -rf "$XDG_CONFIG_HOME"/maven

  rm -rf ~/code/dot/maven/maven/settings.xml

fi

# llama

rm -rf "$XDG_CACHE_HOME"/{huggingface,llama.cpp}

# tmux

rm -rf "$XDG_DATA_HOME"/tmux/plugins/tmux-fzf-links

# zsh

rm -rf "$XDG_CACHE_HOME"/zsh/last-working-dir
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--dirhistory
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--last-working-dir

# zsh-lint

mise install

# one time deep cleanup

"${BASH_SOURCE%/*}"/clean.sh deep

rm -rf "$XDG_CACHE_HOME"/{appstream,cmp}/
rm -rf "$XDG_CONFIG_HOME"/{fsh,github-copilot}/
rm -rf "$XDG_DATA_HOME"/man/
rm -rf "$XDG_STATE_HOME"/{.copilot,pipewire}/

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
