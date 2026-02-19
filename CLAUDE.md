# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Automated Arch Linux installation and configuration management system. Shell scripts (Zsh/Bash) that handle full OS deployment, package installation, service management, and machine-specific configuration across multiple machines.

## Machines

- **drifter** - laptop (128GB root, 300% display scale)
- **player** - gaming desktop (256GB root, 240Hz display, NVIDIA GPU)
- **worker** - workstation (256GB root, dual displays)
- **sacrifice** - AMD GPU server (fan control, no desktop environment)

Each machine has a profile script (e.g. `drifter.zsh`) that sets environment variables (`MY_DISK`, `MY_HOSTNAME`, etc.) used by all other scripts.

## Installation Flow

The scripts run in a specific order during installation:

1. Machine profile (`drifter.zsh` / `player.zsh` / `worker.zsh`) - sets env vars
2. `disk.sh` - LUKS encryption + LVM setup (once per machine) or `unlock.zsh`
3. `system.zsh` - pacstrap base system install
4. `system2.sh` - chrooted post-install (localization, users, systemd)
5. `boot.zsh` / `boot2.sh` - boot manager setup (systemd-boot, limine)
6. `services.zsh` - enable systemd services
7. `apps.zsh` / `work.zsh` - application installation
8. `settings.zsh` / `gdm.zsh` / `gnome.zsh` - configuration
9. `secboot.zsh` / `crypt.zsh` - secure boot and TPM

## Architecture

- **Root scripts** (~96 `.sh`/`.zsh` files) - each handles one concern (a service, app, or setup step)
- **`etc/`** - system config files deployed to `/etc/` (systemd units, udev rules, sysctl, modprobe, iptables, pacman mirrors)
- **`home/`** - user config files deployed to `~/.config/` and `~/.local/share/` (pipewire, wireplumber, fontconfig, GNOME monitors, systemd user services)
- **`boot/`** - boot manager entries and config (systemd-boot, limine)
- **`pkg/`** - custom PKGBUILD packages (llama-cpp-vulkan, intune-portal, microsoft-identity-broker)

Scripts use `pacman` and `paru` (AUR helper) for package management. Machine-specific behavior is controlled by env vars and hostname checks within scripts.

External repo dependencies: `dot` (dotfiles), `walls` (wallpapers), `keys` (SSH), `pass` (passwords), `hist` (shell history), `notes`.

## Linting

```bash
npx eslint .          # lint JavaScript files (eslint.config.mjs)
```

## Code Style

- 2-space indentation, UTF-8, single quotes, trim trailing whitespace (`.editorconfig`)
- Shell scripts: `keep_padding = true`, `space_redirects = true` (shfmt conventions)
- `.sh` files use Bash, `.zsh` files use Zsh
