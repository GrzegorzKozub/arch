#!/usr/bin/env zsh

set -e -o verbose

# Intune Portal does not currently support Arch Linux as a distribution.
# So you have to edit or replace your /etc/os-release file with an Ubuntu one.
# This package provides such a file in /opt/microsoft/intune/share/os-release for this purpose!
#
# Before you can enroll your device, you need to enable the service and timer and then reboot:
# 'sudo systemctl enable intune-daemon.service'
# For GNOME based systems:
# 'systemctl --user enable intune-agent.service intune-agent.timer gnome-keyring-daemon.socket gnome-keyring-daemon.service'
# For Plasma based systems:
# 'systemctl --user enable intune-agent.service intune-agent.timer'
# Then add file as mentioned in https://wiki.archlinux.org/title/KDE_Wallet#Automatic_D-Bus_activation.
#
# The registration file is not in the correct location for Intune Portal to find it.
# So please create the symlink for it:
# 'mkdir -p ~/.local/state/intune'
# 'ln -s ~/.config/intune/registration.toml ~/.local/state/intune/registration.toml'
#

# packages

paru -S --aur --noconfirm \
  intune-portal-bin

# cleanup

# . `dirname $0`/packages.zsh

# dotfiles

# . ~/code/dot/intune.zsh

# https://github.com/recolic/microsoft-intune-archlinux?tab=readme-ov-file
# https://www.reddit.com/r/archlinux/comments/1nwg65t/enrollment_of_arch_linuxpc_in_microsoft_intune/
# https://git.recolic.net/root/microsoft-intune-archlinux
# https://aur.archlinux.org/packages/intune-portal-bin
#https://aur.archlinux.org/packages/microsoft-identity-broker-bin
# https://github.com/siemens/linux-entra-sso
#
