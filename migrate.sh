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

# vm

[[ -d /run/media/$USER/data/vm ]] && find /run/media/"$USER"/data/vm -mindepth 1 -delete

# yazi

ya pkg add yazi-rs/plugins:compress

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
