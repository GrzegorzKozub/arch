#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# claude

if [[ $HOST == 'worker' ]]; then

  rm -rf "$XDG_CONFIG_HOME"/claude/CLAUDE.md

  pushd ~/code/dot

  mkdir -p "$XDG_CONFIG_HOME"/claude/rules

  ln -sf "$(dirname "$(realpath "$0")")"/claude/claude/rules/greg.md \
    "$XDG_CONFIG_HOME"/claude/rules/greg.md

  gh api repos/efficy-sa/apsis-shared-ai/contents/claude-code/CLAUDE.md \
    --jq '.content' | base64 -d > "$XDG_CONFIG_HOME"/claude/rules/apsis.md

  popd

  npx --yes skills add mattpocock/skills \
      --agent claude-code --copy --global --yes \
      --skill \
        codebase-design \
        grill-me \
        grilling \
        handoff \
        improve-codebase-architecture \
        tdd \
        to-spec \
        to-tickets

fi

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

# vscode

rm -rf "$XDG_DATA_HOME"/applications/{code,code-url-handler}.desktop

# worktrunk

yay --aur --noconfirm --answerdiff=None -S worktrunk-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
