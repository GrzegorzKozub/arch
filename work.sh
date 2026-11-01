#!/usr/bin/env bash
set -eo pipefail -ux

# dirs

[[ $HOST == 'worker' ]] && mkdir -p ~/code/apsis

# dev

if [[ $HOST == 'worker' ]]; then

  "${BASH_SOURCE%/*}"/auth0.sh
  "${BASH_SOURCE%/*}"/aws.sh

fi

# apps

if [[ $HOST == 'worker' ]]; then

  "${BASH_SOURCE%/*}"/postman.sh
  "${BASH_SOURCE%/*}"/teams.sh

fi

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# hosts

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/hosts.sh

# dotfiles

[[ $HOST == 'worker' ]] &&  ~/code/dot/work.sh
