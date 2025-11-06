#!/usr/bin/env bash

set -e -o verbose

DIR=/run/media/"$USER"/data/.secrets

# restore updated env vars

BACKUP=$DIR/.zshenv
[[ -f $BACKUP ]] && cp --update "$BACKUP" ~/code/dot/zsh/zsh/.zshenv

# restore updated fetch tokens

BACKUP=$DIR/fetch.env
[[ -f $BACKUP ]] && cp --update "$BACKUP" ~/code/arch/fetch.env

if [[ $HOSTNAME == 'worker' ]]; then # work

  # restore rotated aws access keys

  BACKUP=$DIR/credentials

  [[ -f $BACKUP && -f $AWS_SHARED_CREDENTIALS_FILE ]] &&
    cp --update "$BACKUP" "$AWS_SHARED_CREDENTIALS_FILE"

fi
