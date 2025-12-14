#!/usr/bin/env bash

set -e

# mangohud frame limit doesn't work over 100 fps
# https://docs.bazzite.gg/Gaming/Common_gaming_issues/#frame-rate-limiting-issues-and-inconsistency
export VKD3D_FRAME_RATE=120

export PROTON_DLSS_UPGRADE=1
export PROTON_DLSS_INDICATOR=0

export PROTON_NVIDIA_LIBS_NO_32BIT=1

# required for HDR without gamescope but causes stuttering with VRR
export PROTON_ENABLE_WAYLAND=0

export PROTON_NO_WM_DECORATION=1
export PROTON_ENABLE_HDR=1

export PROTON_USE_NTSYNC=1

export PROTON_LOCAL_SHADER_CACHE=1

export PROTON_PREFER_SDL=1
export PROTON_NO_STEAMINPUT=1

# https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
# https://www.phoronix.com/review/amd-3d-vcache-optimizer-9950x3d
X3D=/sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode
echo cache | sudo tee $X3D

powerprofilesctl launch --profile performance -- \
  mangohud gamemoderun "$@"

# gamescope frame limit currently broken
# exec powerprofilesctl launch --profile performance -- \
#   gamemoderun gamescope \
#   -W 3840 -H 2160 -r 239.99 \
#   --hdr-enabled --mangoapp --adaptive-sync --fullscreen --force-grab-cursor -- \
#   "$@"

echo frequency | sudo tee $X3D
