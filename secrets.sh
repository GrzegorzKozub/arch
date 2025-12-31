#!/usr/bin/env bash

set -e -o verbose

SECRETS=/run/media/"$USER"/data/.secrets

lnk() {
  if [[ -f $1 ]]; then
    ln -sf "$1" "$2"
  else rm -f "$2"; fi
}

# env: ANTHROPIC_API_KEY, GEMINI_API_KEY, GITHUB_TOKEN, OPENAI_API_KEY, RCLONE_DRIVE_CLIENT_SECRET

lnk "$SECRETS"/.zshenv ~/code/dot/zsh/zsh/.zshenv

# fetch env: GITHUB_PAT_EFFICY, GITHUB_PAT_GREG

lnk "$SECRETS"/fetch.env ~/code/arch/fetch.env

# ansible

lnk "$SECRETS"/ansible.secret ~/code/dot/ansible/ansible/ansible.secret

# docker: $SECRETS/docker.secret

# maven

lnk "$SECRETS"/settings.xml ~/code/dot/maven/maven/settings.xml

if [[ $HOST == 'worker' ]]; then

  # TODO: aws (including rotation), ssh

  # restore rotated aws access keys

  BACKUP=$DIR/credentials

  [[ -f $BACKUP && -f $AWS_SHARED_CREDENTIALS_FILE ]] &&
    cp --update "$BACKUP" "$AWS_SHARED_CREDENTIALS_FILE"

fi
