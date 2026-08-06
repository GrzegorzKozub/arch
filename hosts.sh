#!/usr/bin/env bash
set -eo pipefail -ux

LIST=(
  dev.apsis
)

for ITEM in "${LIST[@]}"; do
  sudo sed -i -e "/.*$ITEM.*/d" /etc/hosts
done

for ITEM in "${LIST[@]}"; do
  printf "127.0.0.1 %s\n::1       %s\n" "$ITEM" "$ITEM" | sudo tee --append /etc/hosts > /dev/null
done
