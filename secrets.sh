#!/usr/bin/env bash

set -e -o verbose

[[ $HOSTNAME == 'worker' ]] || return # work

# restore rotated aws access keys

BACKUP=/run/media/"$USER"/data/.secrets/credentials

[[ -f $BACKUP && -f $AWS_SHARED_CREDENTIALS_FILE ]] &&
  cp --update "$BACKUP" "$AWS_SHARED_CREDENTIALS_FILE"
