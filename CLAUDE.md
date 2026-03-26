# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Automated Arch Linux installation and configuration framework. Scripts are run interactively during system setup — they are not unit-tested or CI'd. See [ISSUES.md](ISSUES.md) for known bugs and workarounds.

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

- `drifter.sh` — laptop
- `player.sh` — gaming PC
- `worker.sh` — workstation

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

### Script Conventions

All scripts start with:
```bash
#!/usr/bin/env bash
set -eo pipefail -ux
```

Scripts reference sibling scripts via: `"${BASH_SOURCE%/*}"/other.sh`

System config files live under `etc/` (copied to `/etc/`) and user configs under `home/` (managed via GNU Stow, applied by `dot.sh`).

Custom AUR packages are built locally under `pkg/` — each subdirectory is a makepkg source tree.
