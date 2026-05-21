#!/usr/bin/env bash
set -eo pipefail -ux

# ananicy-cpp

sudo pacman -S --noconfirm ananicy-cpp cachyos-ananicy-rules
sudo systemctl enable --now ananicy-cpp.service

# cachy

"${BASH_SOURCE%/*}"/cachy.sh

sudo pacman --noconfirm -Syu
sudo DIFFPROG='nvim -d' pacdiff

"${BASH_SOURCE%/*}"/settings.sh
"${BASH_SOURCE%/*}"/links.sh
"${BASH_SOURCE%/*}"/gdm.sh
[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && "${BASH_SOURCE%/*}"/gnome.sh
"${BASH_SOURCE%/*}"/mime.sh
"${BASH_SOURCE%/*}"/secrets.sh

sudo pacman -S --noconfirm \
  linux-cachyos \
  linux-cachyos-lts

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo pacman -S --noconfirm linux-cachyos-nvidia-open

sudo cp "${BASH_SOURCE%/*}"/boot/loader/entries/*.conf /boot/loader/entries
sudo cp "${BASH_SOURCE%/*}"/boot/EFI/limine/limine.conf /boot/EFI/limine

sudo bash -c "sed -i 's/<host>/$HOST/g' /boot/EFI/limine/limine.conf"

[[ $HOST == 'drifter' ]] && {
  sudo bash -c "sed -i '/^interface_resolution.*/d' /boot/EFI/limine/limine.conf"
  sudo bash -c "sed -i 's/<font>/3x3/g' /boot/EFI/limine/limine.conf"
}

[[ $HOST == 'player' ]] && {
  sudo bash -c "sed -i '/^interface_resolution.*/d' /boot/EFI/limine/limine.conf"
  sudo bash -c "sed -i 's/<font>/2x2/g' /boot/EFI/limine/limine.conf"
}

[[ $HOST == 'worker' ]] && {
  sudo bash -c "sed -i 's/<res>/1280x720/g' /boot/EFI/limine/limine.conf"
  sudo bash -c "sed -i '/^term_font_scale.*/d' /boot/EFI/limine/limine.conf"
}

[[ $HOST == 'drifter' ]] &&
  sudo bash -c "sed -i 's/<ucode>/intel-ucode/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo bash -c "sed -i 's/<ucode>/amd-ucode/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo bash -c "sed -i 's/<params>/amd_pstate=active <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo bash -c "sed -i 's/<params>/nvidia-drm.modeset=1 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"

[[ $HOST == 'drifter' ]] &&
  sudo bash -c "sed -i 's/<params>/rcutree.enable_rcu_lazy=1 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"

sudo bash -c "sed -i 's/<params>/quiet loglevel=3 rd.udev.log_level=3 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"
sudo bash -c "sed -i 's/ <params>//g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf"

sudo "${BASH_SOURCE%/*}"/limine.sh

paru -S --rebuild --noconfirm tmux-git fswatch

# evolution-data-server

pacman -Q evolution-data-server &> /dev/null ||
  sudo pacman -S --noconfirm evolution-data-server

# kyber

sudo cp "${BASH_SOURCE%/*}"/etc/udev/rules.d/60-ioschedulers.rules /etc/udev/rules.d/

# pacman

sudo sed -i 's/#ILoveCandy/ILoveCandy/' /etc/pacman.conf

# paru

if pacman -Q paru-git-debug &> /dev/null; then
  sudo pacman -Rs --noconfirm paru-git-debug
  "${BASH_SOURCE%/*}"/paru.sh
fi

# sched-ext

sudo pacman -S --noconfirm scx-scheds scx-tools

sudo mkdir -p /etc/scx_loader
sudo cp "${BASH_SOURCE%/*}"/etc/scx_loader/config.toml /etc/scx_loader

sudo systemctl enable scx_loader.service

# thermald

[[ $HOST == 'drifter' ]] && {
  sudo pacman -S --noconfirm thermald
  sudo systemctl enable --now thermald.service
}

# tiddl

pushd ~/code/dot
./reset.sh python
./links.sh
popd

rm -rf ~/.config/tidal_dl_ng-dev

# vpl-gpu-rt

[[ $HOST == 'drifter' ]] &&
  sudo pacman -S --noconfirm vpl-gpu-rt

# yazi

ya pkg add yazi-rs/plugins:toggle-pane || true

# zed

pacman -Q gnu-netcat &> /dev/null &&
  sudo pacman -R --noconfirm gnu-netcat &&
  sudo pacman -S --noconfirm openbsd-netcat || true

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
