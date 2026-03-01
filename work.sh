#!/usr/bin/env bash
set -eo pipefail -ux

# dev

if [[ $HOST == 'worker' ]]; then

  "${BASH_SOURCE%/*}"/ansible.sh
  "${BASH_SOURCE%/*}"/aws.sh
  "${BASH_SOURCE%/*}"/claude.sh
  "${BASH_SOURCE%/*}"/dotnet.sh
  "${BASH_SOURCE%/*}"/java.sh

fi

# apps

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/postman.sh
[[ $HOST =~ ^(drifter|worker)$ ]] && "${BASH_SOURCE%/*}"/teams.sh

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# hosts

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/hosts.sh

# dotfiles

[[ $HOST == 'worker' ]] &&  ~/code/dot/work.sh
