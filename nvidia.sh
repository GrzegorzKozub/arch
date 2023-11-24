#!/usr/bin/env bash

set -e

# sudo nvidia-smi -pm 1 # replaced with nvidia-persistenced.service

sudo nvidia-smi -lgc 210,1900 # default 210,2100
sudo nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=100'

sudo nvidia-smi -pl 330 # default 340

