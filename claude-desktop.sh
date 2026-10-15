#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  claude-desktop

# links

cp /usr/share/applications/com.anthropic.Claude.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e "s|^Exec=claude-desktop|Exec=env CLAUDE_CONFIG_DIR=$XDG_CONFIG_HOME/claude-desktop claude-desktop|" \
  "$XDG_DATA_HOME"/applications/com.anthropic.Claude.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/claude-desktop.sh
