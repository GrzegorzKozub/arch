#!/usr/bin/env bash
set -eo pipefail -ux

# export LLAMA_ARG_CTX_SIZE=65536
# export LLAMA_ARG_FLASH_ATTN=on
# export LLAMA_ARG_MLOCK=on
# export LLAMA_ARG_N_CPU_MOE=0
# export LLAMA_ARG_N_GPU_LAYERS=all

llama-server \
  --ctx-size 65536 \
  --flash-attn on \
  --mlock \
  --n-cpu-moe 0 \
  --n-gpu-layers all \
  --hf-repo unsloth/gemma-4-31B-it-GGUF:UD-Q4_K_XL
