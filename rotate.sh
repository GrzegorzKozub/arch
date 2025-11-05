#!/usr/bin/env bash

set -e

[[ $HOSTNAME == 'worker' ]] || exit 1 # work

grep '^\[' "$AWS_SHARED_CREDENTIALS_FILE" | sed 's/[][]//g' | while read -r PROFILE; do

  ID=$(aws configure get aws_access_key_id --profile "$PROFILE")
  [[ -z ${ID-} ]] && continue

  printf "\e[37m  rotate \e[0m%s\n" "$PROFILE"

  NAME=$(aws sts get-caller-identity \
    --profile "$PROFILE" \
    --query 'Arn' \
    --output text | cut -d / -f 2)

  [[ $ID == $(aws iam list-access-keys \
    --profile "$PROFILE" \
    --user-name "$NAME" \
    --query 'AccessKeyMetadata[].AccessKeyId' \
    --output text) ]] || exit 1

  read -r NEW_ID NEW_KEY < <(
    aws iam create-access-key \
      --profile "$PROFILE" \
      --user-name "$NAME" \
      --output json |
      jq -r '.AccessKey | "\(.AccessKeyId) \(.SecretAccessKey)"'
  )

  [[ -z ${NEW_ID-} || -z ${NEW_KEY-} ]] && exit 1

  aws iam delete-access-key \
    --profile "$PROFILE" --user-name "$NAME" --access-key-id "$ID"

  aws configure set aws_access_key_id "$NEW_ID" --profile "$PROFILE"
  aws configure set aws_secret_access_key "$NEW_KEY" --profile "$PROFILE"

done

cp --update "$AWS_SHARED_CREDENTIALS_FILE" /run/media/"$USER"/data/.secrets/
