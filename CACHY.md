# Migrating to CachyOS

Remaining work

- Rebuild AUR packages with optimized `makepkg.conf` flags via `paru -S --rebuild --noconfirm $(paru -Qm | awk '{print $1}' | grep -v '^llama-cpp-vulkan$')`

- Review [cachyos-settings](https://wiki.cachyos.org/features/cachyos_settings/) and related tools. Confirm this repo already includes all the tweaks.

- Check if all [general system tweaks](https://wiki.cachyos.org/configuration/general_system_tweaks/) are applied via this repo

- See if any more tweaks from [cachyos-hello](https://github.com/CachyOS/CachyOS-Welcome) should be added to this repo

- Check which packages are suggested and installed by [chwd](https://wiki.cachyos.org/features/chwd/chwd/) on each machine

- Discover [sched-ex](https://wiki.cachyos.org/configuration/sched-ext/) and custom schedulers

- Review [gaming guide](https://wiki.cachyos.org/configuration/gaming/) and incorporate with `games.sh`

- Check out [Virtio-Venus](https://wiki.cachyos.org/virtualization/virtio-venus/) and use it in `vm.sh`

- Migrate to `btrfs`

