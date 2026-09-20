#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# cleanup

[[ $HOST == 'worker' ]] && rm -rf "$XDG_CACHE_HOME"/fsh/

# crypttab.initramfs deprecation

# https://github.com/archlinux/mkinitcpio/blob/master/CHANGELOG
# https://wiki.archlinux.org/title/Dm-crypt/System_configuration

# if [[ -f /etc/crypttab.initramfs ]]; then
#   sed 's/$/,x-initrd.attach/' /etc/crypttab.initramfs |
#     sudo tee -a /etc/crypttab > /dev/null
#   sudo rm /etc/crypttab.initramfs
#   sudo mkinitcpio -p linux
#   sudo mkinitcpio -p linux-lts
#   sudo mkinitcpio -p linux-cachyos
#   sudo mkinitcpio -p linux-cachyos-lts
# fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
