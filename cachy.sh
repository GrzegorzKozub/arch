#!/usr/bin/env bash
set -eo pipefail -ux

# cachyos repos - https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install

REPO_URL="https://mirror.cachyos.org/repo/x86_64/cachyos"

# gpg key

sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47

# bootstrap packages - resolve current filenames from package db

TMP="$(mktemp -d)"
trap 'rm -rf $TMP' EXIT

curl -s "$REPO_URL/cachyos.db.tar.gz" | tar -xzf - -C "$TMP"

get_pkg_file() {
  local dir
  dir=$(find "$TMP" -maxdepth 1 -name "$1-*" -type d | head -1)
  awk '/%FILENAME%/{getline; print}' "$dir/desc"
}

sudo pacman -U --noconfirm \
  "$REPO_URL/$(get_pkg_file cachyos-keyring)" \
  "$REPO_URL/$(get_pkg_file cachyos-mirrorlist)" \
  "$REPO_URL/$(get_pkg_file cachyos-v3-mirrorlist)" \
  "$REPO_URL/$(get_pkg_file cachyos-v4-mirrorlist)" \
  "$REPO_URL/$(get_pkg_file pacman)"

# detect cpu tier

if gcc -march=native -Q --help=target 2>&1 | grep -qE 'march.*znver[45]'; then
  TIER=znver4
elif /lib/ld-linux-x86-64.so.2 --help | grep -q 'x86-64-v4 (supported, searched)'; then
  TIER=v4
else
  TIER=v3
fi

# update pacman.conf

sudo cp /etc/pacman.conf /etc/pacman.conf.bak

sudo sed -i 's/^Architecture = x86_64$/Architecture = auto/' /etc/pacman.conf

if ! grep -q '\[cachyos\]' /etc/pacman.conf; then

  if [[ $TIER == znver4 ]]; then
    REPOS="[cachyos-znver4]\nInclude = /etc/pacman.d/cachyos-znver4-mirrorlist\n\n[cachyos-core-znver4]\nInclude = /etc/pacman.d/cachyos-znver4-mirrorlist\n\n[cachyos-extra-znver4]\nInclude = /etc/pacman.d/cachyos-znver4-mirrorlist\n\n[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist\n"
  elif [[ $TIER == v4 ]]; then
    REPOS="[cachyos-v4]\nInclude = /etc/pacman.d/cachyos-v4-mirrorlist\n\n[cachyos-core-v4]\nInclude = /etc/pacman.d/cachyos-v4-mirrorlist\n\n[cachyos-extra-v4]\nInclude = /etc/pacman.d/cachyos-v4-mirrorlist\n\n[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist\n"
  else
    REPOS="[cachyos-v3]\nInclude = /etc/pacman.d/cachyos-v3-mirrorlist\n\n[cachyos-core-v3]\nInclude = /etc/pacman.d/cachyos-v3-mirrorlist\n\n[cachyos-extra-v3]\nInclude = /etc/pacman.d/cachyos-v3-mirrorlist\n\n[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist\n"
  fi

  sudo awk -v repos="$REPOS" '
    /^\[core\]/ && !done { printf "%s\n", repos; done=1 }
    { print }
  ' /etc/pacman.conf.bak | sudo tee /etc/pacman.conf > /dev/null

fi

# sync databases

sudo pacman -Sy

# rate mirrors before full upgrade to avoid 404s
# https://wiki.cachyos.org/cachyos_basic/why_cachyos/#cachyos-custom-applications

sudo pacman -S --noconfirm cachyos-rate-mirrors
sudo cachyos-rate-mirrors

# full upgrade

sudo pacman -Syu --noconfirm
