# Known issues

Known issues and workarounds

## Claude Code

Sandbox is broken

- https://github.com/anthropics/claude-code/issues/17087

## GDM

The settings from `monitors.xml` are not applied

- https://bbs.archlinux.org/viewtopic.php?id=308479
- https://github.com/gdm-settings/gdm-settings/issues/285

## Intune

Intune `libgobject-2.0.so.0` coredump

- https://git.recolic.net/root/microsoft-intune-archlinux/-/issues/3

## Limine

No Bitlocker support

- https://codeberg.org/Limine/Limine/issues/12

## Paru

Leaves `/var/cache/pacman/pkg/download-*` files behind

- https://forum.endeavouros.com/t/solved-latest-pacman-update-breaks-aur-and-yay/76959

Workaround

```bash
sudo rm -rf /var/cache/pacman/pkg/download-*
```

## Teams

Crash when joining a meeting with camera

- https://github.com/IsmaelMartinez/teams-for-linux/issues/2169

Workaround

```bash
rm -rf ~/.config/teams-for-linux/Partitions/teams-4-linux/Local\ Storage
```

