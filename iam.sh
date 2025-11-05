#!/usr/bin/env bash

export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_SDK_LOAD_CONFIG=1

grep '^\[' "$AWS_SHARED_CREDENTIALS_FILE" | sed 's/[][]//g' | while read -r PROFILE; do

  ID=$(aws configure get aws_access_key_id --profile "$PROFILE")
  [[ -z ${ID-} ]] && continue

  aws iam get-access-key-last-used --profile "$PROFILE" --access-key-id "$ID"

done
