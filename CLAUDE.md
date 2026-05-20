# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Related Repos

- [dot](https://github.com/GrzegorzKozub/dot) — dotfiles, managed via GNU Stow, lives at `~/code/dot`
- [hist](https://github.com/GrzegorzKozub/hist) — shell history
- [toys](https://github.com/GrzegorzKozub/toys) — hardware spec & config; monitor calibration docs
- [walls](https://github.com/GrzegorzKozub/walls) — curated wallpapers

## Overview

Automated Arch Linux installation and configuration framework. Scripts are run interactively during system setup — they are not unit-tested or CI'd. Known bugs and workarounds are in [README.md](README.md) under the **Issues** section.

## Linting

```bash
npm install               # install ESLint/Prettier (for JSONC files)
npx eslint .              # lint JS/JSONC files
npx prettier --check .    # check formatting
shellcheck <script>.sh    # lint shell scripts
```

## Architecture

### Machine Configs

Three target machines, each with its own config script that exports environment variables consumed by all other scripts:

- `drifter.sh` — laptop (Intel CPU, no discrete GPU)
- `player.sh` — gaming PC (AMD CPU + NVIDIA GPU)
- `worker.sh` — workstation (AMD CPU + NVIDIA GPU)

Variables exported: `MY_HOSTNAME`, `MY_DISK`, `MY_EFI_PART`, `MY_EFI_PART_NBR`, `MY_ARCH_PART`, `MY_DESKTOP`.

Scripts gate machine-specific behavior with: `if [[ $HOST =~ ^(player|worker)$ ]]` or `if [[ $MY_HOSTNAME == drifter ]]`.

### Installation Order

1. `source drifter.sh` (or player/worker) — set machine variables
2. `disk.sh` — LUKS2 encryption + LVM setup (once per machine)
3. `unlock.sh` — unlock existing encrypted partition (subsequent installs)
4. `system.sh` → `system2.sh` → `system3.sh` — base OS via `pacstrap`, chroot config
5. `boot.sh` → `boot2.sh` — Limine bootloader setup
6. `services.sh` — enable systemd services
7. `apps.sh` — user applications
8. `work.sh` — work-specific tools (drifter + worker only)
9. `secboot.sh` — Secure Boot via sbctl (once per machine)
10. `preloader.sh disable` — disable PreLoader (after secboot)
11. `crypt.sh` — TPM2-based auto-unlock

### Maintenance Scripts

Run on a live system (not during installation):

- `update.sh` — pulls this repo, upgrades all packages, runs `pacdiff`, reapplies settings
- `migrate.sh` — post-update migrations: adds CachyOS repos, rebuilds AUR packages, applies Limine config, runs cleanup
- `b.sh` — backup root filesystem to encrypted data partition via `fsarchiver`
- `r.sh` — restore root filesystem from backup (latest or a specific dir)
- `sync.sh` — git pull/push across companion repos (walls, hist, keys, pass, notes) in parallel

### Script Conventions

All scripts start with:
```bash
#!/usr/bin/env bash
set -eo pipefail -ux
```

Scripts reference sibling scripts via: `"${BASH_SOURCE%/*}"/other.sh`

### Config File Layout

- `etc/` — system config files; scripts copy these to `/etc/` directly
- `home/` — a small set of user config files stored here (e.g. ICC color profiles under `home/.local/share/icc/`); main dotfiles live in a separate `~/code/dot` repo managed via GNU Stow
- `boot/` — Limine bootloader config templates with `<placeholder>` tokens (e.g. `<host>`, `<ucode>`, `<params>`) replaced via `sed` at install/update time
- `pkg/` — custom AUR packages built locally; each subdirectory is a `makepkg` source tree
- `dot.sh` — clones companion repos (arch, walls, dot, hist, keys, pass, notes) from GitHub using a temporary SSH key from the archiso pendrive

### CachyOS Integration

This installs standard Arch Linux then layers CachyOS-optimized packages on top via `cachy.sh`, which adds the CachyOS repository and replaces packages like the kernel (`linux-cachyos`, `linux-cachyos-lts`), scheduler, and CPU governor settings.
