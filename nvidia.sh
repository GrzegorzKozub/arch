#!/bin/sh

set -e

sudo nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffset[4]=-150'

# sudo nvidia-persistenced
# sudo nvidia-smi --power-limit 325

