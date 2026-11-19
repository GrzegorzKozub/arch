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

# teams

[[ $HOST == 'worker' ]] && rm -rf ~/.local/share/applications/teams-for-linux.desktop

# vm

[[ -d /run/media/$USER/data/vm ]] && find /run/media/"$USER"/data/vm -mindepth 1 -delete

# yazi

ya pkg add yazi-rs/plugins:compress

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
