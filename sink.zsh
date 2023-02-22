#!/usr/bin/env zsh

RUNNING_ID=$(pactl list short sinks | grep 'RUNNING' | cut -f1)

pactl list short sinks | while read -r id name driver s1 s2 s3 state; do
  [[ $PREVIOUS == 1 ]] && pactl set-default-sink $id
  [[ $id == $RUNNING_ID ]] && PREVIOUS=1
done

