#!/usr/bin/env bash

export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_SDK_LOAD_CONFIG=1

grep '^\[' "$AWS_SHARED_CREDENTIALS_FILE" | sed 's/[][]//g' | while read -r PROFILE; do
  echo "$PROFILE"
  ID=$(aws configure get aws_access_key_id --profile "$PROFILE")
  echo "$ID"
  [[ -z ${ID-} ]] && continue
  aws sts get-caller-identity \
    --profile "$PROFILE" \
    --query Arn \
    --output text | cut -d / -f 2
done

# https://github.com/efficy-sa/apsis-audience-infra/blob/2c6f98d8f8b2b97b4efd261c15f9b0d2f0c8881f/utils/rotate-access-keys.sh
