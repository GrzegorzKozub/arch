# Migrating to CachyOS

Remaining work

- Review [cachyos-settings](https://wiki.cachyos.org/features/cachyos_settings/) and related tools. Confirm this repo already includes all the tweaks.

- Check if all [general system tweaks](https://wiki.cachyos.org/configuration/general_system_tweaks/) are applied via this repo

- See if any more tweaks from [cachyos-hello](https://github.com/CachyOS/CachyOS-Welcome) should be added to this repo

- Check which packages are suggested and installed by [chwd](https://wiki.cachyos.org/features/chwd/chwd/) on each machine

- Discover [sched-ex](https://wiki.cachyos.org/configuration/sched-ext/) and custom schedulers

- Review [gaming guide](https://wiki.cachyos.org/configuration/gaming/) and incorporate with `games.sh`

- Check out [Virtio-Venus](https://wiki.cachyos.org/virtualization/virtio-venus/) and use it in `vm.sh`

- Migrate to `btrfs`

---

## cachyos-settings gap analysis

Most sysctl values from [CachyOS-Settings](https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/70-cachyos-settings.conf) are already in `etc/sysctl.d/70-perf.conf`. Gaps remain:

### 1. `fs.file-max` missing from sysctl

Add to `etc/sysctl.d/70-perf.conf`:
```
fs.file-max = 2097152
```

### 2. NVMe I/O scheduler: `none` → `kyber`

CachyOS uses `kyber` (lightweight multi-queue scheduler with QoS) instead of `none`. Update `etc/udev/rules.d/60-ioschedulers.rules`:
```
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
```


