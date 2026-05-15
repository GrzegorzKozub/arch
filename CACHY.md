# Migrating to CachyOS

## Background: What CachyOS Migration Actually Does

Adding CachyOS repos to an existing Arch system:
1. Replaces many core packages with **x86-64-v3/v4 or znver4 optimized** binaries (LTO, BOLT, AVX2/AVX512)
2. Installs a **forked pacman** with `INSTALLED_FROM` tracking and automatic architecture checks
3. Gives you access to **`linux-cachyos`** kernel variants

You do **not** reinstall the OS. Package replacement happens automatically via `pacman -Syu` once the repos are added with higher priority than `[core]`/`[extra]`.

---

## Part 1: In-Place Migration (Existing Machines)

### Step 1 — Backup

```bash
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
```

> On ext4 (no Btrfs snapshots). Have your LUKS recovery key accessible (saved during `systemd-cryptenroll`). Keep a live Arch ISO nearby.

---

### Step 2 — Check Your CPU Architecture

```bash
/lib/ld-linux-x86-64.so.2 --help | grep -E 'supported|x86-64'
```

- **drifter** (Intel laptop): likely **x86-64-v3**
- **player/worker** (AMD): Zen 3 = v3, Zen 4/5 = v4/znver4

The automated script handles this detection, but it's good to know in advance.

---

### Step 3 — Add CachyOS Repositories

```bash
curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
yes | sudo ./cachyos-repo.sh
```

The script detects your CPU tier, backs up `pacman.conf`, imports GPG keys, and installs `cachyos-keyring`, `cachyos-mirrorlist`, and a customized pacman.

**What it installs to `pacman.conf`** (example for v3 CPU, placed *above* `[core]`):

```ini
[cachyos-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos-core-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos-extra-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
```

> **Pacman fork note:** The `[cachyos]` repo replaces pacman with a CachyOS fork. It adds an architecture check that will warn when upgrading if the installed package was built for a different arch tier. This is benign.

---

### Step 4 — Refresh Mirrors and Upgrade All Packages

If you hit 404 errors during the upgrade, refresh mirrors first:

```bash
sudo cachyos-rate-mirrors
# check for permissions bug
ls -la /etc/pacman.d/cachyos-*mirrorlist
sudo chmod 644 /etc/pacman.d/cachyos-*mirrorlist
```

Then upgrade:

```bash
sudo rm -f /var/lib/pacman/db.lck
sudo pacman -Syu
```

---

### Step 5 — Choose and Install a CachyOS Kernel

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

### Step 6 — Add Boot Entries

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

#### systemd-boot — create `/boot/loader/entries/cachyos.conf`

```
title    CachyOS BORE
sort-key 01
linux    /vmlinuz-linux-cachyos-bore
initrd   /amd-ucode.img
initrd   /initramfs-linux-cachyos-bore.img
options  root=/dev/mapper/vg1-root resume=/dev/mapper/vg1-swap rw amd_pstate=active nvidia-drm.modeset=1 quiet loglevel=3 rd.udev.log_level=3
```

---

### Step 7 — Sign the New Kernel for Secure Boot

```bash
sudo sbctl sign --save /boot/vmlinuz-linux-cachyos        # or vmlinuz-linux-cachyos-bore
sudo sbctl list-files
sudo sbctl verify
```

> **TPM2 note:** `systemd-cryptenroll` seals against PCR7 (Secure Boot state). Adding a new signed binary does not change PCR7 — no re-enrollment needed. Re-enrollment is only required after re-running `secboot.sh` (key changes). Use `crypt.sh --fix-tpm` afterward if that happens.

---

### Step 8 — Test Boot

```bash
sudo reboot
# select CachyOS entry from Limine menu
uname -r          # verify new kernel
sbctl status      # secure boot on
sbctl verify      # all signed files pass
```

---

### Step 9 — Remove Old Kernels (Once Stable)

```bash
sudo pacman -R linux linux-headers linux-lts linux-lts-headers
# remove corresponding Limine and systemd-boot entries
```

---

### Step 10 — Optional: CachyOS-Specific Tools

```bash
sudo pacman -S cachyos-kernel-manager   # GUI: switch schedulers, configure sched-ext
sudo pacman -S scx-scheds               # runtime sched-ext schedulers
sudo systemctl enable --now scx
```

---

## Part 2: Repo Script Changes (Fresh Installs)

### `system2.sh`

The `cachyos.sh` call already adds repos. After that, also install the CachyOS kernel:

```bash
[[ $MY_HOSTNAME == 'player' ]] && pacman -S --noconfirm linux-cachyos-bore linux-cachyos-bore-headers linux-cachyos-bore-nvidia-open
[[ $MY_HOSTNAME != 'player' ]] && pacman -S --noconfirm linux-cachyos linux-cachyos-headers

pacman -R --noconfirm linux linux-headers linux-lts linux-lts-headers 2>/dev/null || true
```

Update the mkinitcpio calls:

```bash
[[ $MY_HOSTNAME == 'player' ]] && mkinitcpio -p linux-cachyos-bore
[[ $MY_HOSTNAME != 'player' ]] && mkinitcpio -p linux-cachyos
```

### `boot2.sh` / `limine.conf` / boot entries

Add CachyOS entries using the same `<ucode>` and `<params>` template pattern.

### `secboot.sh`

Add to the signing loop:

```
vmlinuz-linux-cachyos \
vmlinuz-linux-cachyos-bore \
```

---

## Key Gotchas

**Limine 11.2+ BLAKE2B:** Newer Limine enforces config checksums when Secure Boot is active. If you hit a "Limine panic" on first boot after adding the CachyOS entry, you need to embed the config hash into the EFI binary (`limine-enroll-config`). Your local Limine is 12.2.0 (ahead of CachyOS repos at 11.4.1) — check the [CachyOS Secure Boot wiki](https://wiki.cachyos.org/configuration/secure_boot_setup/).

**NVIDIA open modules:** `linux-cachyos-bore-nvidia-open` ships prebuilt open kernel modules — no more building via dkms on every kernel update.

**AMD `amd_pstate=active`:** Keep this kernel param on player/worker. The CachyOS kernel has patches that work well with the EPP driver.

**TPM2 re-enrollment after Secure Boot changes:** If you re-run `secboot.sh`, run `crypt.sh --fix-tpm` afterward.

**Version warnings on upgrade:** Warnings like `local (x) is newer than cachyos (y)` are harmless — pacman won't downgrade unless forced. Notable: limine 12.2.0 local vs 11.4.1 in CachyOS repos — leave it on the Arch version.

**Mirror 404s:** If `pacman -Syu` hits 404s, run `sudo cachyos-rate-mirrors`, check file permissions (`chmod 644 /etc/pacman.d/cachyos-*mirrorlist`), then retry.
