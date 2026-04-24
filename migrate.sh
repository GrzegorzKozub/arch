#!/usr/bin/env bash
set -eo pipefail -ux

# claude

rm -rf ~/code/dot/claude/claude/settings.worker.json

# nvim

rm -rf "$XDG_DATA_HOME"/applications/nvim.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
