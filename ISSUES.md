# Known issues

Known issues and workarounds

## Claude Code

Sandbox is broken

- https://github.com/anthropics/claude-code/issues/17087

## dbus

Multiple errors like `dbus-broker-launch[1170]: Ignoring duplicate name 'ca.desrt.dconf' in service file '/usr/share//dbus-1/services/ca.desrt.dconf.service'` in journal

- https://bbs.archlinux.org/viewtopic.php?pid=2294025

## GDM

Suspends right after waking up from suspending via GNOME

- https://gitlab.gnome.org/GNOME/gdm/-/issues/1029

Workaround

Set `sleep-inactive-ac-type` & `sleep-inactive-battery-type` to `nothing` inside GDM dconf

## Intune

Intune `libgobject-2.0.so.0` coredump

- https://git.recolic.net/root/microsoft-intune-archlinux/-/issues/3

## Limine

No Bitlocker support

- https://codeberg.org/Limine/Limine/issues/12

## Lua

When `lua-luarocks` installs, its post-install script runs `make_manifest` for all Lua version trees, including `rocks-5.5/`. The `lua54-filesystem` package only populates `rocks-5.4/`. When another package like `lua-luacheck` exists in `rocks-5.5/` and declares  `luafilesystem` as a dependency, the manifest generator can't find the corresponding  `rock_manifest` there — hence the error. The install itself still succeeds — this is a non-fatal post-install hook failure. To fix this, install the Lua 5.5 variant of `lua-filesystem` with `sudo pacman -S lua-filesystem`. This populates `rocks-5.5/luafilesystem/` so the manifest can be generated correctly on future upgrades.

- https://bbs.archlinux.org/viewtopic.php?pid=2292385

## Mutter

When maximizing a window, mutter triggers unredirection (direct scanout that bypasses the compositor and writes directly to the display. On NVIDIA and Wayland, this simultaneously triggers a VRR mode transition on the LG 27UL850-W, which the driver can't handle cleanly on that monitor resulting in a blank screen. This happens due to a narrow VRR range of 40–61Hz on that monitor.

- https://gitlab.gnome.org/GNOME/mutter/-/issues/1410
- https://gitlab.gnome.org/GNOME/mutter/-/issues/3419

Workaround

Extension `unredirect` prevents mutter from trigerring unredirection but that's a global change. Instead, VRR is disabled on LG 27UL850-W via `monitors.xml`.

## Pacman

Pacman 7.0 introduced sandboxed downloading where temporary `download-*` dirs are owned by `alpm:alpm`. Pacman 7.1 worsened it — a fix for an edge case broke cleanup in normal successful transactions. This results in leaving `/var/cache/pacman/pkg/download-*` files behind.

- https://gitlab.archlinux.org/pacman/pacman/-/work_items/297

Workaround

```bash
sudo rm -rf /var/cache/pacman/pkg/download-*
```

