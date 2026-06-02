#!/usr/bin/env bash
set -eo pipefail -ux

# claude

pushd ~/code/dot
ln -sf "$(dirname "$(realpath "$0")")"/claude/claude/subagent-statusline.sh \
  "$XDG_CONFIG_HOME"/claude/subagent-statusline.sh
popd

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
