#!/usr/bin/env bash
set -eo pipefail -ux

# https://github.com/ggml-org/llama.cpp/discussions/14758
# https://github.com/ggml-org/llama.cpp/discussions/15396

llama-server -hf ggml-org/gpt-oss-20b-GGUF \
  --ctx-size 131072 \
  --n-cpu-moe 16 \
  --no-kv-offload \
  --flash-attn on \
  --gpu-layers all \
  --cache-type-k q4_0 --cache-type-v q4_0
