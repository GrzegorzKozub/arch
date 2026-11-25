#!/usr/bin/env bash
set -eo pipefail -ux

# update self

pushd "${BASH_SOURCE%/*}" && git pull && popd
[[ ${PULLED:-} ]] || PULLED=1 exec "$BASH" "$0" "$@"
unset PULLED

# btop

pushd ~/code/dot
git update-index --no-assume-unchanged btop/btop/btop.conf
git pull
popd

# prep

pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# TODO: undo on player & worker
# cachyos-v3 ships stale nvidia-open 620.70.06-0 that requires missing nvidia-utils 620.70.06
# sudo pacman --noconfirm --needed -Su cachyos-extra-v3/nvidia-open

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

# obsidian

if [[ -L $XDG_CONFIG_HOME/obsidian ]]; then

  rm "$XDG_CONFIG_HOME"/obsidian
  cp -a ~/code/dot/obsidian/obsidian "$XDG_CONFIG_HOME"/obsidian

  pushd ~/code/dot
  git clean -fdx obsidian
  stow --target="$XDG_CONFIG_HOME" --no-folding --adopt --stow obsidian
  popd

fi

# tidal

if [[ -L $XDG_CONFIG_HOME/tidal-hifi ]]; then

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

ya pkg add yazi-rs/plugins:compress || true

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
