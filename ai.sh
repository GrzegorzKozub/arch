#!/usr/bin/env bash
set -eo pipefail -ux

# https://github.com/ggml-org/llama.cpp/discussions/14758
# https://github.com/ggml-org/llama.cpp/discussions/15396

llama-server \
  --ctx-size 32768 \
  --flash-attn on \
  --gpu-layers all \
  --n-cpu-moe 0 \
  --no-kv-offload \
  -hf Qwen/Qwen3-8B-GGUF:Q4_K_M

  # Qwen/Qwen3-8B-GGUF:Q4_K_M
  # ggml-org/gpt-oss-20b-GGUF
  # unsloth/Devstral-Small-2-24B-Instruct-2512-GGUF:Q4_K_M
  # unsloth/GLM-4.6V-Flash-GGUF:Q4_K_M
  # unsloth/GLM-4.7-Flash-GGUF:Q4_K_M
