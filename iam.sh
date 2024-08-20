#!/usr/bin/env bash

export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_SDK_LOAD_CONFIG=1

for PROFILE in 'apsis-au-stage' 'apsis-waw-stage' 'apsis-webscript-stage'; do

  ID=$(cat $AWS_SHARED_CREDENTIALS_FILE |
    grep --after-context 1 $PROFILE |
    grep aws_access_key_id |
    cut -d' ' -f3)

  export AWS_PROFILE=$PROFILE
  aws iam get-access-key-last-used --access-key-id $ID

done

