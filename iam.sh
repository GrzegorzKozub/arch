#!/usr/bin/env bash

export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_PROFILE=apsis-waw-stage
export AWS_SDK_LOAD_CONFIG=1

ID=$(cat $AWS_SHARED_CREDENTIALS_FILE |
  grep --after-context 1 apsis-waw-stage |
  grep aws_access_key_id |
  cut -d' ' -f3)

aws iam get-access-key-last-used --access-key-id $ID

