# Migrating to CachyOS

## TODO

- Rebuild AUR packages with optimized makepkg.conf flags: `paru -S --rebuild --noconfirm $(paru -Qm | awk '{print $1}' | grep -v '^llama-cpp-vulkan$')`

- Review CachyOS custom applications: https://wiki.cachyos.org/cachyos_basic/why_cachyos/#cachyos-custom-applications

- Enable `PrettyProgressBar` and `ILoveCandy` in `/etc/pacman.conf` (both commented out in the pacnew from CachyOS pacman 7.0; `ILoveCandy` is the old name, `PrettyProgressBar` is the new canonical name for the same feature)

- Script the CachyOS kernel install, boot entries, and Secure Boot signing (Steps 4–7 below)

## Background: What CachyOS Migration Actually Does

Adding CachyOS repos to an existing Arch system:
1. Replaces many core packages with **x86-64-v3/v4 or znver4 optimized** binaries (LTO, BOLT, AVX2/AVX512)
2. Installs a **forked pacman** with `INSTALLED_FROM` tracking and automatic architecture checks
3. Gives you access to **`linux-cachyos`** kernel variants

You do **not** reinstall the OS. Package replacement happens automatically via `pacman -Syu` once the repos are added with higher priority than `[core]`/`[extra]`.

---

## Scripts

CachyOS support is gated on `MY_CACHY=1` in the machine config (`drifter.sh`, `player.sh`, `worker.sh`).

**`cachy.sh`** — adds CachyOS repos to the running system. Idempotent. Used by both fresh install and migration flows:
- Imports GPG key
- Installs keyring, mirrorlist, and forked pacman packages (resolved from live DB, no hardcoded versions)
- Detects CPU tier (znver4/v4/v3) via gcc, falls back to ld
- Updates `/etc/pacman.conf` (backs up original before first modification)
- Syncs DB and runs `cachyos-rate-mirrors`
- Does **not** run `pacman -Syu` — callers decide when to upgrade

**Fresh install** (`system.sh` → `system2.sh`):
- `cachy.sh` runs on the live ISO before pacstrap, configuring repos and mirrors
- pacstrap uses the live ISO's CachyOS-configured pacman — installs optimized packages directly
- `/etc/pacman.conf` is copied into the chroot after pacstrap
- `cachyos-rate-mirrors` re-runs inside the chroot (gated on `MY_CACHY`)

**Migration** (`migrate.sh`):
- Calls `cachy.sh` then `pacman -Syu --noconfirm` (gated on `MY_CACHY`)

---

## After Running the Scripts: Manual Steps

### Step 1 — Choose and Install a CachyOS Kernel

| Variant | Scheduler | Best for |
|---|---|---|
| `linux-cachyos` | EEVDF (tuned) | General use, laptop (drifter) |
| `linux-cachyos-bore` | BORE | Gaming, interactive desktop (player) |
| `linux-cachyos-lto` | EEVDF | Max optimization, workstation (worker) |
| `linux-cachyos-lts` | EEVDF | Stability fallback |

**Recommended per machine:**
- **drifter** (laptop): `linux-cachyos`
- **player** (gaming PC): `linux-cachyos-bore`
- **worker** (workstation): `linux-cachyos` or `linux-cachyos-lto`

```bash
# player
sudo pacman -S linux-cachyos-bore linux-cachyos-bore-headers linux-cachyos-bore-nvidia-open

# drifter / worker
sudo pacman -S linux-cachyos linux-cachyos-headers
```

Kernel files land at:
- `/boot/vmlinuz-linux-cachyos` (or `vmlinuz-linux-cachyos-bore`)
- `/boot/initramfs-linux-cachyos.img`
- `/boot/initramfs-linux-cachyos-fallback.img`

mkinitcpio runs automatically via the `.preset` file the package provides.

---

### Step 2 — Add Boot Entries

#### Limine — edit `/boot/EFI/limine/limine.conf`

For **player** (AMD, BORE kernel):

```
/CachyOS BORE
  protocol: linux
  path: boot():/vmlinuz-linux-cachyos-bore
  module_path: boot():/amd-ucode.img
  module_path: boot():/initramfs-linux-cachyos-bore.img
  cmdline: root=/dev/mapper/vg1-root resume=/dev/mapper/vg1-swap rw amd_pstate=active nvidia-drm.modeset=1 quiet loglevel=3 rd.udev.log_level=3
```

For **drifter** (Intel, standard kernel):

```
/CachyOS
  protocol: linux
  path: boot():/vmlinuz-linux-cachyos
  module_path: boot():/intel-ucode.img
  module_path: boot():/initramfs-linux-cachyos.img
  cmdline: root=/dev/mapper/vg1-root resume=/dev/mapper/vg1-swap rw rcutree.enable_rcu_lazy=1 quiet loglevel=3 rd.udev.log_level=3
```

---

### Step 3 — Sign the New Kernel for Secure Boot

```bash
sudo sbctl sign --save /boot/vmlinuz-linux-cachyos        # or vmlinuz-linux-cachyos-bore
sudo sbctl list-files
sudo sbctl verify
```

> **TPM2 note:** `systemd-cryptenroll` seals against PCR7 (Secure Boot state). Adding a new signed binary does not change PCR7 — no re-enrollment needed. Re-enrollment is only required after re-running `secboot.sh` (key changes). Use `crypt.sh --fix-tpm` afterward if that happens.

---

### Step 4 — Test Boot

```bash
sudo reboot
# select CachyOS entry from Limine menu
uname -r          # verify new kernel
sbctl status      # secure boot on
sbctl verify      # all signed files pass
```

---

### Step 5 — Remove Old Kernels (Once Stable)

```bash
sudo pacman -R linux linux-headers linux-lts linux-lts-headers
# remove corresponding Limine entries
```

---

### Step 6 — Optional: CachyOS-Specific Tools

```bash
sudo pacman -S cachyos-kernel-manager   # GUI: switch schedulers, configure sched-ext
sudo pacman -S scx-scheds               # runtime sched-ext schedulers
sudo systemctl enable --now scx
```

---

## Key Gotchas

**Limine 11.2+ BLAKE2B:** Newer Limine enforces config checksums when Secure Boot is active. If you hit a "Limine panic" on first boot after adding the CachyOS entry, you need to embed the config hash into the EFI binary (`limine-enroll-config`). Your local Limine is 12.2.0 (ahead of CachyOS repos at 11.4.1) — check the [CachyOS Secure Boot wiki](https://wiki.cachyos.org/configuration/secure_boot_setup/).

**NVIDIA open modules:** `linux-cachyos-bore-nvidia-open` ships prebuilt open kernel modules — no more building via dkms on every kernel update.

**AMD `amd_pstate=active`:** Keep this kernel param on player/worker. The CachyOS kernel has patches that work well with the EPP driver.

**TPM2 re-enrollment after Secure Boot changes:** If you re-run `secboot.sh`, run `crypt.sh --fix-tpm` afterward.

**Version warnings on upgrade:** Warnings like `local (x) is newer than cachyos (y)` are harmless — pacman won't downgrade unless forced. Notable: limine 12.2.0 local vs 11.4.1 in CachyOS repos — leave it on the Arch version.

**Mirror 404s:** If `pacman -Syu` hits 404s, run `sudo cachyos-rate-mirrors`, check file permissions (`chmod 644 /etc/pacman.d/cachyos-*mirrorlist`), then retry.

**cachy.sh uses upstream script as reference only:** We don't call the official `cachyos-repo.sh` because it runs `pacman -Syu` without first running `cachyos-rate-mirrors`, causing 404s. Our implementation adds the mirror refresh step before the upgrade.
