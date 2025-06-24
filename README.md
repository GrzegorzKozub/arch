# Arch

Automated Arch Linux installation

## Archiso

1. Create a DOS partition table on the pendrive
2. Add a FAT32 partition with the boot flag
3. Prepare the partition for `archisosearchuuid` param
  - Set the UUID to a known value with `sudo mlabel -i /dev/sdb1 :: -N 12345678`
  - Label with `sudo mlabel -i /dev/sdb1 ::archiso`
  - Verify with `lsblk -lno PATH,FSTYPE,UUID`
4. Build with `~/code/arch/archiso.zsh`
5. Copy with
  ```bash
  rm -rf /run/media/$USER/ARCHISO/(arch|boot|EFI|loader|shellia32.efi|shellx64.efi)
  cp -r ~/code/arch/archiso/usb/* /run/media/$USER/ARCHISO
  ```

## Installation

1. Boot from archiso
2. Run `source ~/arch/drifter.zsh`, `source ~/arch/player.zsh` or `source ~/arch/worker.zsh`
3. Once per machine, run `~/arch/disk.sh`, otherwise run `~/arch/unlock.zsh`
4. Run `~/arch/system.zsh`
5. Once per machine, run `~/arch/boot.zsh`
6. Reboot to Arch and login as normal user
7. Run `~/code/arch/services.zsh`
8. Reboot to GNOME, login as normal user and connect to internet
9. Run `~/code/arch/apps.zsh`
10. Reboot
11. Once per machine, run `~/arch/secboot.zsh` and backup afterwards
12. Once per machine and after each `secboot.zsh` run, run `~/arch/crypt.zsh`
13. Reboot & backup

### Manual config

1. Brave
  - Join the Sync Chain and sync everything
  - Setup your profiles
  - Sign in to your sites
  - Set as default browser
  - Disable everything except background images on the dashboard
  - Don't show tab groups in bookmarks
  - Hide bookmarks
  - Hide side panel button
  - Hide bookmarks button
  - Hide Brave News button in address bar
  - Don't allow suggestions Leo AI Assistant
  - Hide Leo AI button
  - Hide Brave Rewards button
  - Hide VPN button
  - Hide tab search button
  - Set fixed-width font to Cascadia Code
  - Cycle through the most recently used tabs with Ctrl-Tab
  - Don't show Wayback Machine prompts on 404 pages
  - Don't show the number of blocked items on the Shields icon
  - Disable EasyList Cookie content filter
  - Don't allow sites to send notifications
  - Disable data collection
  - Don't show Leo icon in the sidebar
  - Don't show Leo in the context menu on websites
  - Don't offer to save passwords and passkeys
  - Don't sign in automatically
  - Add Polish and enable spell check for it
  - Don't use Brave Translate
  - Don't ask where to save downloaded files
  - Don't continue running background apps when Brave is closed
  - Don't warn me before closing window with multiple tabs
  - Enable Memory Saver
  - Disable Brave VPN
2. GNOME
  - Set display refresh rate on player to variable 144 Hz and on worker to variable 60 Hz
  - Set display scale on drifter to 300% and on player & worker to 200%
  - Select the sound device and set volume to 50%
3. KeePassXC
  - Open your databases
  - Hide folders panel
  - Only show title and username columns, also in search
  - Fit to window, also in search
  - Configure Brave extension
4. Postman
  - Change font to `Cascadia Code`
  - Change font size to `14`
  - Change tab size to `2`
  - Sign in
5. Visual Studio Code
  - Hide recommended extensions
  - Disable tweet feedback icon
  - Sign in
6. Zed
  - Configure the assistant
  - Sign in
7. Run `clean.zsh`
8. Prepare the `~/.config/zsh/.zshenv` and `~/code/arch/fetch.env` files
9. Fix window sizes and positions

## New disk

Existing backup can be used when changing disks or moving partitions

1. Boot from archiso
2. Use `disk.sh` to encrypt Linux partition with LUKS and create LVM volumes inside
3. Use `r.zsh` to restore `/boot` and `/` from latest backup
4. Use `boot.zsh` to add Linux Boot Manager to EFI
5. Change root to the restored installation
  ```bash
  mount /dev/mapper/vg1-root /mnt
  mount /dev/nvme0n1p2 /mnt/boot # EFI partition
  arch-chroot /mnt
  ```
6. Use `blkid` to get the partition UUIDs and update them in `/etc/fstab`
7. Update Linux partition UUID in `/etc/crypttab.initramfs` and re-create initial ramdisk
  ```bash
  mkinitcpio -p linux && mkinitcpio -p linux-lts
  ```
8. Exit, unmount and reboot
9. Use `crypt.zsh` to enable unlocking Linux partition using TPM and save recovery key

## Wayland

To enable Wayland on NVIDIA

- Add `nvidia_drm.modeset=1` kernel module setting
- Ensure no `WaylandEnable=false` in `/etc/gdm/custom.conf`
- Ensure [video memory is preserved during suspend](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend)

### XDG Desktop Portal

XDP implementations conflict each other so only one should be installed at the same time:

- GNOME - `xdg-desktop-portal-gnome` and `xdg-desktop-portal-gtk`
- KDE - `xdg-desktop-portal-kde`
- Hyprland - `xdg-desktop-portal-hyprland`
- Sway - `xdg-desktop-portal-wlr`

## Colors

Monitors were calibrated as described in the [toys](https://github.com/GrzegorzKozub/toys) repo. Color profiles are loaded using `colord` via `settings.zsh`.

To test if a profile is loaded use this `dispwin` command from `argyllcms` package:

```zsh
dispwin -d1 -V ~/code/arch/home/greg/.local/share/icc/27gp950-b.icm
```

### NVIDIA

[The wiki states](https://wiki.archlinux.org/title/ICC_profiles#Loading_ICC_profiles) that NVIDIA is not compatible with `colord` so previously `dispwin` was used to load the color profiles. This required disabling `colord.service` which made it necessary to use `redshift` for night light.

Neither `dispwin` nor `redshift` are compatible with Wayland.

Testing with `dispwin` showed that the only visible problem is that launching NVIDIA settings breaks the colors. This can be fixed by either turning the color profile off and on again in GNOME settings or loading it using `dispwin`.

For these reasons `dispwin` and `redshift` were removed in commit [f78146b](https://github.com/GrzegorzKozub/arch/commit/f78146b51d2523dffbbbb770391d63141942a985).

## Fonts

Comfortable settings for display scale on Wayland given the screen size and resolution:

- drifter: 300%
- player & worker: 200%

Font scaling factor is always at 1.

The aim is to standardize on the font size of `1em` or `12pt` or `16px` ([converter](https://simplecss.eu/pxtoems.html)) and achieve about 50 lines (or 40 lines on drifter) of full screen text in terminal and code editors.

Current settings:

- Alacritty, Foot, Ghostty & Kitty: `12pt` (or `1em` or `16px`)
- Brave, Code, Obsidian & Postman: `16px` (or `1em` or `12pt`)

## GNOME Shell extensions

To test on Wayland run `dbus-run-session -- env MUTTER_DEBUG_DUMMY_MODE_SPECS=2560x1440 gnome-shell --nested --wayland`.

### References

- [GJS](https://gjs.guide/)
- [GNOME JavaScript Docs](https://gjs-docs.gnome.org/)

## Windows VM

During the installation, put Windows and [virtio-win](https://github.com/virtio-win/virtio-win-pkg-scripts) iso in `$DIR`. Install disk, graphics card and network card drivers from virtio-win. Disable fast startup. Map `\\10.0.2.4\qemu` as network drive on guest.

For Secure Boot with TPM 2.0 install `swtpm` and `edk2-ovmf` on host.

For clipboard sharing using spice install `virt-viewer` on host and [guest tools](https://www.spice-space.org/download.html) on guest.

For folder sharing using spice install `virt-viewer` on host and [webdav daemon](https://www.spice-space.org/download.html) on guest. Run `c:\Program Files (x86)\SPICE webdavd\map-drive.bat` on guest.

To reduce the image size after freeing up space on guest, first defragment the drives and run `sdelete -z` on guest, then run `qemu-img convert -O qcow2 from.cow to.cow`.

## Gaming

1. Run `~/code/arch/games.zsh`
2. Reboot
3. Start Steam
4. Once per machine, configure Steam, and specifically
  - Don't sign in to friends when Steam starts
  - Disable non-critical notifications and hide non-critical notifications while in game
  - Set start up location to Library
  - Disable community content and hide game icons in Library
  - Enable shader pre-caching and allow background processing of Vulkan shaders
  - Disable Steam overlay and remove screenshot shortcut
  - Enable Steam Play for supported and all other titles
  - Disable Remote Play
  - For each game, set game compatibility to Proton-GE
5. Once per machine, move Steam to games disk with
  ```bash
  mv $XDG_DATA_HOME/Steam /run/media/$USER/games/
  ln -s /run/media/$USER/games/Steam $XDG_DATA_HOME/Steam
  ```

### Launch options

- Elden Ring, VKD3D

`./er-patcher --rate 144 -vcas -- env LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" PROTON_ENABLE_NGX_UPDATER=1 PROTON_ENABLE_NVAPI=1 VKD3D_CONFIG=dxr11,dxr WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_MODE=ultra WINE_FULLSCREEN_FSR_STRENGTH=2 mangohud gamemoderun %command%`

### References

- [dxvk](https://github.com/doitsujin/dxvk)
- [gamescope](https://github.com/Plagman/gamescope)
- [libstrangle](https://gitlab.com/torkel104/libstrangle)
- [MangoHud](https://github.com/flightlessmango/MangoHud)
- [proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom)
- [vkd3d-proton](https://github.com/HansKristian-Work/vkd3d-proton)

## Discussions

- [Hardware video acceleration with VA-API](https://bbs.archlinux.org/viewtopic.php?id=244031)

