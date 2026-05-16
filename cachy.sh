#!/usr/bin/env bash
set -eo pipefail -ux

# https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install
# https://raw.githubusercontent.com/CachyOS/cachyos-repo-add-script/master/cachyos-repo.sh

# keyring

sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47

# packages

TMP="$(mktemp -d)"
trap 'rm -rf $TMP' EXIT
pushd "$TMP"

MIRROR=https://mirror.cachyos.org/repo/x86_64/cachyos
curl -s "$MIRROR"/cachyos.db | tar --zstd -xf - -C "$TMP"

package() {
  local dir
  dir=$(find "$TMP" -maxdepth 1 -name "$1-*" -type d | head -1)
  awk '/%FILENAME%/{getline; print}' "$dir"/desc
}

PKGS=()
for PKG in \
  cachyos-keyring \
  cachyos-mirrorlist \
  cachyos-v3-mirrorlist \
  cachyos-v4-mirrorlist \
  cachyos-znver4-mirrorlist \
  pacman; do
  pacman -Qq "$PKG" &> /dev/null || PKGS+=("$MIRROR/$(package "$PKG")")
done

[[ ${#PKGS[@]} -gt 0 ]] && sudo pacman -U --noconfirm "${PKGS[@]}"

popd

# pacman.conf update

if ! grep -q '\[cachyos\]' /etc/pacman.conf; then

  sudo cp /etc/pacman.conf /etc/pacman.conf.bak

  sudo pacman -S --noconfirm --needed gcc

  MARCH=$(gcc -march=native -Q --help=target 2>&1)

  if echo "$MARCH" | grep -qE 'march.*znver[45]'; then
    CPU=znver4
  elif /lib/ld-linux-x86-64.so.2 --help | grep -q 'x86-64-v4 (supported, searched)'; then
    CPU=v4
  else
    CPU=v3
  fi

  if [[ $CPU == znver4 ]]; then
    REPOS=$(
            cat << 'EOF'
[cachyos-znver4]
Include = /etc/pacman.d/cachyos-znver4-mirrorlist

[cachyos-core-znver4]
Include = /etc/pacman.d/cachyos-znver4-mirrorlist

[cachyos-extra-znver4]
Include = /etc/pacman.d/cachyos-znver4-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    )
  elif [[ $CPU == v4 ]]; then
    REPOS=$(
            cat << 'EOF'
[cachyos-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-core-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-extra-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    )
  else
    REPOS=$(
            cat << 'EOF'
[cachyos-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos-core-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos-extra-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    )
  fi

  sudo awk -v repos="$REPOS" '
    /^\[core\]/ && !done { printf "%s\n\n", repos; done=1 }
    { print }
  ' /etc/pacman.conf.bak | sudo tee /etc/pacman.conf > /dev/null

fi

# pacman db sync

sudo pacman -Sy

# install & run cachyos-rate-mirrors to avoid 404s (reason for not using automatic script)

sudo pacman -S --noconfirm --needed cachyos-rate-mirrors
sudo cachyos-rate-mirrors
