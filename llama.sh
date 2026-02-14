#!/usr/bin/env bash
set -eo pipefail -ux

# https://github.com/ggml-org/llama.cpp/discussions/14758
# https://github.com/ggml-org/llama.cpp/discussions/15396

export LLAMA_ARG_CTX_SIZE=32768
export LLAMA_ARG_FLASH_ATTN=on
export LLAMA_ARG_N_CPU_MOE=22
export LLAMA_ARG_MLOCK=on
export LLAMA_ARG_N_GPU_LAYERS=all

llama-server \
  --hf-repo unsloth/Qwen3-Coder-Next-GGUF:Q4_K_M
# llama-server \
#   --ctx-size 32768 \
#   --flash-attn on \
#   --n-cpu-moe 22 \
#   --mlock \
#   --hf-repo unsloth/Qwen3-Coder-Next-GGUF:Q4_K_M

  # -hf Qwen/Qwen3-8B-GGUF:Q4_K_M

  # --gpu-layers all \

  # Qwen/Qwen3-8B-GGUF:Q4_K_M
  # ggml-org/gpt-oss-20b-GGUF
  # unsloth/Devstral-Small-2-24B-Instruct-2512-GGUF:Q4_K_M
  # unsloth/GLM-4.6V-Flash-GGUF:Q4_K_M
  # unsloth/GLM-4.7-Flash-GGUF:Q4_K_M
  # unsloth/Qwen3-Coder-Next-GGUF:Q4_K_M
