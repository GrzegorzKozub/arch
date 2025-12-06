#!/usr/bin/env bash

# https://forum.foldingathome.org/viewtopic.php?p=372040

set -e

if [[ $HOST == 'player' ]]; then # 5090

  # default 180,3090 per nvidia-smi --query-supported-clocks=gr
  sudo nvidia-smi -lgc 180,2685

  # 3090 - 2685 - 1
  sudo nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=404'

  # default 600
  # sudo nvidia-smi -pl 400

fi

if [[ $HOST == 'worker' ]]; then # 3080

  # default 210,2100 per nvidia-smi --query-supported-clocks=gr
  sudo nvidia-smi -lgc 210,1900

  sudo nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=100'

  # default 340
  # sudo nvidia-smi -pl 330

fi
