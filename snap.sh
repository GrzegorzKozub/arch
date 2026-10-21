#!/usr/bin/env bash
set -eo pipefail -x

[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -E 0 -en "$0" "$0" "$@" || :

DATA=/run/media/$USER/data

# repo

export RESTIC_REPOSITORY=${RESTIC_REPOSITORY:-$DATA/snaps}
[[ -f $RESTIC_REPOSITORY/config ]] || restic init

# claude

if [[ -d $DATA/.config/claude ]]; then

  restic backup \
    --skip-if-unchanged \
    --tag claude \
    "$DATA"/.config/claude

  restic forget \
    --keep-within-daily 7d --keep-within-weekly 21d --keep-within-monthly 3m \
    --prune \
    --tag claude

fi
