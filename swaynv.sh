#!/usr/bin/env bash

# wlroots does not support hardware cursor
export WLR_NO_HARDWARE_CURSORS=1

# avoids flickering (requires vulkan-validation-layers)
export WLR_RENDERER=vulkan

# opengl
export __GL_GSYNC_ALLOWED=0
export __GL_VRR_ALLOWED=0
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export GBM_BACKEND=nvidia-drm

exec sway --unsupported-gpu -D noscanout "$@"

