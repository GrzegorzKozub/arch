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

# zsh

rm -rf ~/.cache/zsh/last-working-dir
rm -rf ~/.local/share/zi/snippets/OMZ::plugins--dirhistory
rm -rf ~/.local/share/zi/snippets/OMZ::plugins--last-working-dir

# zsh-lint

mise install

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
