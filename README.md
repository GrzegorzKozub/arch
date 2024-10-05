# Arch

Automated Arch Linux installation

## Prerequisites

* Windows, along with the EFI partition are already installed. EFI partition size is increased to 512 MB
* There's at least 80 GB unassigned space on the disk for Arch
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows)

### Archiso

1. Create a DOS partition table on the pendrive
2. Add a FAT32 partition with the boot flag
3. Label the partition with `sudo mlabel -i /dev/sda1 ::archiso`
4. Build with `~/code/arch/archiso.zsh`
5. Copy with
  ```bash
  rm -rf /run/media/$USER/ARCHISO/(arch|boot|EFI|loader|shellia32.efi|shellx64.efi)
  cp -r ~/code/arch/archiso/usb/* /run/media/$USER/ARCHISO
  ```

## Installation

1. Boot from archiso
2. Run `source ~/arch/player.zsh`, `source ~/arch/drifter.zsh` or `source ~/arch/worker.zsh`
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
  - Setup your profiles
  - Sign in to your sites
  - Set as default browser
  - Hide bookmarks
  - Hide side panel button
  - Hide bookmarks button
  - Hide Brave News button in address bar
  - Only allow suggestions from top sites, history and bookmarks (not Leo)
  - Hide Leo AI button
  - Hide Brave Rewards button
  - Hide VPN button
  - Hide tab search button
  - Cycle through the most recently used tabs with Ctrl-Tab
  - Disable everything except background images on the dashboard
  - Enable search and URL autocompletion
  - Disable EasyList Cookie content filter
  - Don't show the number of blocked items on the Shields icon
  - Disable product analytics, daily usage ping and diagnostic reports
  - Enable Safe Browsing
  - Don't allow sites to send notifications
  - Join the Sync Chain and sync everything
  - Set the default search engine
  - Install your extensions
  - Disable wallets and hide the button
  - Don't offer to save passwords and don't sign in automatically
  - Add Polish and enable spell check for it
  - Don't offer to translate pages
  - Don't ask where to save downloaded files
  - Don't show Wayback Machine prompts on 404 pages
  - Don't continue running background apps
  - Disable Brave VPN
  - Enable Memory Saver
2. KeePassXC
  - Open your databases
  - Only show attachment, title and username columns
  - Hide folders panel & fit columns to window
  - Configure Brave extension
3. Change font to `Cascadia Code`, font size to `14` and tab size to `2` in Postman
4. Hide recommended extensions and disable tweet feedback icon in Visual Studio Code
5. GNOME
  - Set display refresh rate on player to variable 144 Hz
  - Set display scale on drifter to 300% and on player & worker to 200%
  - Select the sound device and set volume to 50%
6. Run `clean.zsh`
7. Prepare the `~/.config/zsh/.zshenv` and `~/code/arch/fetch.env` files
8. Fix window sizes and positions

## Wayland

Brave, Code, Alacritty, Foot, Kitty, Obsidian & Postman run in native Wayland.

### Problems

- Fractorial scaling makes the text blurry for native Wayland apps and [the whole interface blurry for XWayland apps](https://gitlab.gnome.org/GNOME/mutter/-/issues/2328)
- GNOME text scaling factor not supported by the apps in native Wayland
- [KeePassXC auto-type not supported in native Wayland](https://github.com/keepassxreboot/keepassxc/issues/2281)

### Enabling on NVIDIA

- Add `nvidia_drm.modeset=1` kernel module setting
- Ensure no `WaylandEnable=false` in `/etc/gdm/custom.conf`
- Ensure [video memory is preserved during suspend](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend)

### Forcing native Wayland

Force native Wayland for QT apps with `QT_QPA_PLATFORM=wayland`

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

Comfortable settings for display scale & font scaling factor given the screen size and resolution:

- drifter
  - Wayland - 300% & 1
  - X11 - 200% & 1.25
- player & worker
  - Wayland - 200% & 1
  - X11 - 100% & 1.75

The aim is to standardize on the font size of `1em` or `12pt` or `16px` ([converter](https://simplecss.eu/pxtoems.html)) and achieve about 50 lines (or 40 lines on drifter) of full screen text across all apps.

Current settings:

- Alacritty, Foot & Kitty: `12pt` (or `1em` or `16px`)
- Brave, Code, Obsidian & Postman: `16px` (or `1em` or `12pt`)

### Font scaling factor

Apps running on X11 or XWayland respect font scaling factor. For native Wayland apps, the font size can be adjusted to simulate font scaling factor.

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

To install Windows with a local account, when the wizard starts, press `Shift+F10` to bring up the command prompt. Type `OOBE\BYPASSNRO`. The wizard restarts. Enter the command prompt again. Type `ipconfig /release` to disconnect from the Internet.

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

- Cemu, VULKAN

`LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" PROTON_ENABLE_NGX_UPDATER=1 PROTON_ENABLE_NVAPI=1 python3 ./save_sync mangohud gamemoderun %command% -f -g "<game file>"`

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

