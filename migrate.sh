#!/usr/bin/env bash
set -eo pipefail -ux

# prep

pushd "${BASH_SOURCE%/*}" && git pull && popd
pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# claude

if [[ $HOST != 'worker' ]]; then

  npx --yes skills add mattpocock/skills \
    --agent claude-code --copy --global --yes \
    --skill \
    grill-me \
    grilling \
    handoff

  rm -rf "$XDG_STATE_HOME"/skills/

fi

# ghostty

[[ $HOST == 'drifter' ]] && rm -rf ~/.local/share/applications/com.mitchellh.ghostty.desktop

# nvidia

# if [[ $HOST =~ ^(player|worker)$ ]]; then
#
#   # cachyos-v3 ships stale nvidia-open 620.70.06-0 that requires missing nvidia-utils=620.70.06
#   sudo pacman --noconfirm --needed -Su cachyos-extra-v3/nvidia-open
#
# fi

# obsidian

if [[ -L $XDG_CONFIG_HOME/obsidian ]]; then

  while pgrep -f '^electron[0-9]* /usr/lib/obsidian/app.asar' > /dev/null; do
    read -rp 'Close Obsidian and press Enter'
  done

  rm "$XDG_CONFIG_HOME"/obsidian
  cp -a ~/code/dot/obsidian/obsidian "$XDG_CONFIG_HOME"/obsidian

  pushd ~/code/dot
  git clean -fdx obsidian
  stow --target="$XDG_CONFIG_HOME" --no-folding --adopt --stow obsidian
  popd

fi

# postman

if [[ $HOST == 'worker' ]]; then

  sudo pacman -Rs --noconfirm postman-bin || true
  rm -f ~/.local/share/applications/postman.desktop

  rm -rf ~/.local/bin/lib/
  rm -f ~/.local/bin/postman

  rm -f ~/.local/share/man/man1/postman.1
  [[ -d ~/.local/share/man ]] && find ~/.local/share/man -type d -empty -delete

  rm -rf ~/{.postman,Postman}/

  rm -f ~/.config/Postman
  sed -i '/^x-scheme-handler\/postman=/d' ~/.config/mimeapps.list

fi

# teams

[[ $HOST == 'worker' ]] && rm -rf ~/.local/share/applications/teams-for-linux.desktop

if [[ -L $XDG_CONFIG_HOME/teams-for-linux ]]; then

  while pgrep -x teams-for-linux > /dev/null; do
    read -rp 'Close Teams and press Enter'
  done

  rm "$XDG_CONFIG_HOME"/teams-for-linux
  cp -a ~/code/dot/teams-for-linux/teams-for-linux "$XDG_CONFIG_HOME"/teams-for-linux

  pushd ~/code/dot
  git clean -fdx teams-for-linux
  stow --target="$XDG_CONFIG_HOME" --no-folding --adopt --stow teams-for-linux
  popd

fi

# tidal

if [[ -L $XDG_CONFIG_HOME/tidal-hifi ]]; then

  while pgrep -x tidal-hifi > /dev/null; do
    read -rp 'Close Tidal and press Enter'
  done

  rm "$XDG_CONFIG_HOME"/tidal-hifi
  cp -a ~/code/dot/tidal-hifi/tidal-hifi "$XDG_CONFIG_HOME"/tidal-hifi

  pushd ~/code/dot
  git clean -fdx tidal-hifi
  stow --target="$XDG_CONFIG_HOME" --no-folding --adopt --stow tidal-hifi
  popd

fi

# vm

[[ -d /run/media/$USER/data/vm ]] && find /run/media/"$USER"/data/vm -mindepth 1 -delete

# vscode

if [[ -L $XDG_CONFIG_HOME/vscode/user-data ]]; then

  while pgrep -x code > /dev/null; do
    read -rp 'Close VS Code and press Enter'
  done

  rm "$XDG_CONFIG_HOME"/vscode/user-data
  cp -a ~/code/dot/vscode/user-data "$XDG_CONFIG_HOME"/vscode/user-data
  rm -rf "$XDG_CONFIG_HOME"/vscode/user-data/{.editorconfig,.git,.gitattributes,.gitignore}

  pushd ~/code/dot/vscode/user-data
  git clean -fdx
  popd

  pushd ~/code/dot
  stow --target="$XDG_CONFIG_HOME"/vscode --no-folding --adopt --stow vscode
  popd

fi

# yazi

ya pkg add yazi-rs/plugins:compress

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
