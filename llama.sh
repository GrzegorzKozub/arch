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
  --hf-repo unsloth/GLM-4.7-Flash-GGUF:Q4_K_M

  # --hf-repo Qwen/Qwen3-8B-GGUF:Q4_K_M
  # --hf-repo ggml-org/gpt-oss-20b-GGUF
  # --hf-repo unsloth/GLM-4.7-Flash-GGUF:Q4_K_M
  # --hf-repo unsloth/Qwen3-Coder-Next-GGUF:Q4_K_M
