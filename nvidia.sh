#!/usr/bin/env bash

set -e

if [[ $HOST == 'player' ]]; then # 5090

  # sudo nvidia-smi -lgc ... # default ...
  # sudo nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=...'

  sudo nvidia-smi -pl 400 # default 600

  echo 0

fi

if [[ $HOST == 'worker' ]]; then # 3080

  sudo nvidia-smi -lgc 210,1900 # default 210,2100
  sudo nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=100'

  sudo nvidia-smi -pl 330 # default 340

fi
