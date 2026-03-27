# Known issues

Known issues and workarounds

## Claude Code

Sandbox is broken

- https://github.com/anthropics/claude-code/issues/17087

## GDM

Suspends right after waking up from suspending via GNOME

- https://gitlab.gnome.org/GNOME/gdm/-/issues/1029
- https://discourse.gnome.org/t/gnome-suspends-a-few-seconds-after-waking/31678/17
- https://bbs.archlinux.org/viewtopic.php?id=127740

The settings from `monitors.xml` are not applied

- https://bbs.archlinux.org/viewtopic.php?id=308479
- https://github.com/gdm-settings/gdm-settings/issues/285

## Intune

Intune `libgobject-2.0.so.0` coredump

- https://git.recolic.net/root/microsoft-intune-archlinux/-/issues/3

## Limine

No Bitlocker support

- https://codeberg.org/Limine/Limine/issues/12

## Mutter

When maximizing a window, mutter triggers unredirection (direct scanout that bypasses the compositor and writes directly to the display. On NVIDIA and Wayland, this simultaneously triggers a VRR mode transition on the LG 27UL850-W, which the driver can't handle cleanly on that monitor resulting in a blank screen. This happens due to a narrow VRR range of 40–61Hz on that monitor.

- https://gitlab.gnome.org/GNOME/mutter/-/issues/1410
- https://gitlab.gnome.org/GNOME/mutter/-/issues/3419

Workaround

Extension `unredirect` prevents mutter from trigerring unredirection but that's a global change. Instead, VRR is disabled on LG 27UL850-W via `monitors.xml`.

## Paru

Leaves `/var/cache/pacman/pkg/download-*` files behind

- https://forum.endeavouros.com/t/solved-latest-pacman-update-breaks-aur-and-yay/76959

Workaround

```bash
sudo rm -rf /var/cache/pacman/pkg/download-*
```

