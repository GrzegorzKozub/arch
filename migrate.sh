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

# llama

rm -rf "$XDG_CACHE_HOME"/{huggingface,llama.cpp}

# tmux

rm -rf "$XDG_DATA_HOME"/tmux/plugins/tmux-fzf-links

# zsh

rm -rf "$XDG_CACHE_HOME"/zsh/last-working-dir
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--dirhistory
rm -rf "$XDG_DATA_HOME"/zi/snippets/OMZ::plugins--last-working-dir

# zsh-lint

mise install

# one time deep cleanup

"${BASH_SOURCE%/*}"/clean.sh deep

rm -rf "$XDG_CACHE_HOME"/{appstream,cmp,fsh}/
rm -rf "$XDG_CONFIG_HOME"/{fsh,github-copilot}/
rm -rf "$XDG_DATA_HOME"/man/
rm -rf "$XDG_STATE_HOME"/{.copilot,pipewire}/

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
