# Arch

My automated Arch Linux installation with CachyOS optimizations

Related repos

- [dot](https://github.com/GrzegorzKozub/dot) - dotfiles
- [hist](https://github.com/GrzegorzKozub/hist) - shell history
- [toys](https://github.com/GrzegorzKozub/toys) - hardware spec & config
- [walls](https://github.com/GrzegorzKozub/walls) - curated wallpapers

## To do

- [ ] Migrate to `btrfs` following Arch & CachyOS guides
- [ ] Switch the IO scheduler from `kyber` to [ADIOS](https://wiki.cachyos.org/configuration/general_system_tweaks/#how-to-enable-adios) when it's stable

## Archiso

1. Create a DOS partition table on a pendrive
2. Add a FAT32 partition with the boot flag
3. Prepare the partition for the `archisosearchuuid` param
  - Set the UUID to a known value with `sudo mlabel -i /dev/sdb1 :: -N 12345678`
  - Verify with `lsblk -lno PATH,FSTYPE,UUID`
4. Label the partition with `sudo mlabel -i /dev/sdb1 ::archiso`
5. Build with `~/code/arch/archiso.sh`

## Installation

1. Boot from archiso
2. Run `source ~/arch/drifter.sh`, `source ~/arch/player.sh` or `source ~/arch/worker.sh`
3. Use `cfdisk` to create Linux filesystem partition as `$MY_ARCH_PART` (`cfdisk` can sort partitions)
4. Once per machine, run `~/arch/disk.sh`, otherwise run `~/arch/unlock.sh`
5. Run `~/arch/system.sh`
6. Once per machine, run `~/arch/boot.sh`
7. Reboot to Arch and login as normal user
8. Run `~/code/arch/services.sh`
9. Reboot to GNOME, login as normal user and connect to internet on drifter
10. Once per machine, prepare secrets
11. Run `~/code/arch/apps.sh` and `~/code/arch/work.sh` on drifter and worker
12. Reboot
13. Once per machine, run `~/code/arch/secboot.sh` (backup required after)
14. Once per machine, run `~/code/arch/preloader.sh disable` (after `secboot.sh`)
15. Once per machine and after each `secboot.sh` run, run `~/code/arch/crypt.sh`
16. If required, run `~/code/arch/intune.sh` and `~/code/arch/edge.sh` on drifter and worker
17. Reboot & backup

### Manual config

1. GNOME
  - Set display refresh rate: player 240 Hz variable, worker 144 Hz variable & 60 Hz fixed
  - Set display scale: drifter 300%, player & worker 200%
  - Remove all folders from dash
2. KeePassXC
  - Open your databases
  - Only show title and username columns, also in search
  - Fit to window, also in search
  - Setup browser integration
    - For Brave, enable browser integration. This creates `$XDG_CONFIG_HOME/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json`.
    - For Brave Origin, set a custom Chromium browser configuration location at `~/.config/BraveSoftware/Brave-Origin/NativeMessagingHosts`. This creates `org.keepassxc.keepassxc_browser.json` in that dir.
3. Brave
  - Join the Sync Chain and sync everything
  - Setup your profiles
  - Set as default browser
  - Disable everything except background images on the dashboard
  - Hide all buttons except Forward and Install app in toolbar customization
  - Don't show tab groups in bookmarks
  - Don't allow suggestions Leo AI Assistant
  - Use wide address bar
  - Show rounded corners on main content areas
  - Set fixed-width font to Cascadia Code (on Windows)
  - Cycle through the most recently used tabs with Ctrl-Tab
  - Don't show Wayback Machine prompts on 404 pages
  - Don't show the number of blocked items on the Shields icon
  - Enable YouTube Shorts Blocker content filter
  - Don't allow sites to send notifications
  - Disable data collection
  - Don't show Leo icon in the sidebar
  - Don't show Leo in the context menu on websites
  - Disable Tab Focus Mode
  - Set normal window search engine to Google
  - Don't offer to save passwords and passkeys
  - Don't sign in automatically
  - Add Polish and enable spell check for it
  - Don't use Brave Translate
  - Don't ask where to save downloaded files
  - Don't continue running background apps when Brave is closed
  - Don't warn me before closing window with multiple tabs
  - Don't show full screen reminder to press Esc on exit
  - Enable Memory Saver
  - Disable Brave VPN (on Windows)
  - Import KeePassXC extension settings from `~/code/dot/keepassxc-browser.json`
  - Connect KeePassXC databases using `apsis|greg-linux|windows-drifter|player|worker` naming scheme for the identifiers
  - Sign in into your sites and setup passkeys
4. Tidal
  - Sign in
5. Visual Studio Code
  - Sign in: GitHub
  - Pick LLM
  - Hide recommended extensions
6. Zed
  - Sign in: Zed, collab panel
  - Configure LLM providers: Zed, Anthropic, GitHub Copilot Chat, Google AI, OpenAI
  - Configure edit predictions
7. Claude Code (work)
  - Sign in
  - Configure via `/config`: Dynamic workflow size - medium
8. Postman (work)
  - Sign in
  - Change font family to `Cascadia Code`
  - Change font size to `14`
  - Change indentation count to `2`
  - Don't send anonymous usage data
  - Disable AI
  - Only show collections and environments in workspace
9. Teams (work)
  - Follow operating system theme
  - Switch to compact chat message density
  - Disable notification display
  - Disable all apps
10. Intune (work)
  - Sign in
  - Register device
11. Edge (work)
  - Disable everything during the first launch wizard
  - Switch to international edition and disable everything on new tab page
  - Name your profile or sign in
  - Disable Microsoft Rewards
  - Don't share browsing data with other Windows features
  - Disable everything except showing Reveal password button under Passwords and autofill
  - Block notifications
  - Disable everything under Search and connected experiences
  - Switch search engine used in address bar to Google
  - Disable everything under Copilot and AI
  - Hide favorites on toolbar
  - Don't show mini menu when selecting text
  - Don't show quick actions when hovering on videos
  - Disable visual search
  - Set fixed-width font to Cascadia Code (on Windows)
  - Don't allow sidebar apps to show notifications
  - Don't show tab search
  - Don't show tab preview on hover
  - Open tabs from the previous session on startup
  - Add Polish
  - Don't offer to translate pages that aren't in a language I read
  - Don't offer to translate videos on supported sites
  - Don't use 'Help me write' writing assistant on the web
  - Don't use text prediction
  - Switch to Microsoft Editor under Writing assistance
  - Disable startup boost
  - Don't continue running background extensions and apps when Edge is closed
12. Fix window sizes and positions

## New disk

Existing backup can be used when changing disks or moving partitions

1. Boot from archiso
2. Use `disk.sh` to encrypt Linux partition with LUKS and create LVM volumes inside
3. Use `r.sh` to restore `/boot` and `/` from latest backup
4. Use `boot.sh` to add Linux Boot Manager to EFI
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
9. Use `crypt.sh` to enable unlocking Linux partition using TPM and save recovery key

## Wayland

To enable Wayland on NVIDIA

- Add `nvidia_drm.modeset=1` kernel module setting
- Ensure no `WaylandEnable=false` in `/etc/gdm/custom.conf`
- Ensure [video memory is preserved during suspend](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend)

### XDG Desktop Portal

XDP implementations conflict each other so only one should be installed at the same time

- GNOME - `xdg-desktop-portal-gnome` and `xdg-desktop-portal-gtk`
- Niri - `xdg-desktop-portal-gnome` and `xdg-desktop-portal-gtk`

## Colors

Monitors were calibrated as described in the [toys](https://github.com/GrzegorzKozub/toys) repo. Color profiles are loaded using `colord` via `settings.sh`.

To test if a profile is loaded use this `dispwin` command from `argyllcms` package

```bash
dispwin -d1 -V ~/code/arch/home/.local/share/icc/mpg321urx.icm
```

## Fonts

Comfortable settings for display scale on Wayland given the screen size and resolution

- drifter: 300%
- player & worker: 200%

Font scaling factor is always at 1.

The aim is to standardize on the font size of `1em` or `12pt` or `16px` ([converter](https://simplecss.eu/pxtoems.html)) and achieve about 50 lines (or 40 lines on drifter) of full screen text in terminal and code editors.

Current settings

- Ghostty & Kitty: `12pt` (or `1em` or `16px`)
- Brave, Code, Obsidian, Zed: `16px` (or `1em` or `12pt`)
- Postman: `14px` (or `0.88em` or `11pt`)

## GNOME Shell extensions

Install `mutter-devkit` and run `dbus-run-session -- gnome-shell --devkit` to test & debug.

### References

- [GJS](https://gjs.guide/)
- [GNOME JavaScript Docs](https://gjs-docs.gnome.org/)

## Intune

Based on [Intune for Arch Linux](https://git.recolic.net/root/microsoft-intune-archlinux) and these AUR packages

- [microsoft-identity-broker-bin](https://aur.archlinux.org/packages/microsoft-identity-broker-bin) ([sources](https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/m/microsoft-identity-broker/))
- [intune-portal-bin](https://aur.archlinux.org/packages/intune-portal-bin) ([sources](https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/i/intune-portal/))

Use Entra SSO with Brave via [linux-entra-sso](https://github.com/siemens/linux-entra-sso)

## Windows VM

During the installation, put Windows and [virtio-win](https://github.com/virtio-win/virtio-win-pkg-scripts) iso in `$DIR`. Install disk, graphics card and network card drivers from virtio-win. Disable fast startup. Map `\\10.0.2.4\qemu` as network drive on guest.

For Secure Boot with TPM 2.0 install `swtpm` and `edk2-ovmf` on host.

For clipboard sharing using spice install `virt-viewer` on host and [guest tools](https://www.spice-space.org/download.html) on guest.

For folder sharing using spice install `virt-viewer` on host and [webdav daemon](https://www.spice-space.org/download.html) on guest. Run `c:\Program Files (x86)\SPICE webdavd\map-drive.bat` on guest.

To reduce the image size after freeing up space on guest, first defragment the drives and run `sdelete -z` on guest, then run `qemu-img convert -O qcow2 from.cow to.cow`.

## Gaming

1. Run `~/code/arch/games.sh`
2. Reboot
3. Once per machine, start and configure Steam
  - Don't sign in to Friends when Steam starts
  - Never show notification toasts
  - Enable 24-hour clock, enable Beta, set start up location to Library, don't run Steam on startup, disable update notifications, enable GPU accelerated rendering and hardware video decoding and enable SteamRT3
  - Leave only Store, Library, Settings and Exit Steam in taskbar preferences
  - Disable community content, hide game icons and show Steam Deck compatibility in Library
  - Disable shader pre-caching
  - Add favorite library
  - Disable Steam overlay, remove overlay shortcut key and remove screenshot key
  - Show performance monitor on top-left, toggle with `F8`, show only FPS details without avg/min graph, set text size scaling to 3, set text saturation and background opacity to 0
  - Set default compatibility tool to Proton-CachyOS or Proton-GE
  - Disable Remote Play
  - Sort by recent activity and show only ready to play games
4. Once per machine, move Steam to games disk with
  ```bash
  mv $XDG_DATA_HOME/Steam /run/media/$USER/games/
  ln -s /run/media/$USER/games/Steam $XDG_DATA_HOME/Steam
  ```
5. Set game launch options to `~/code/arch/game.sh %command%`

### References

- [Bazzite Gaming Guide](https://docs.bazzite.gg/Gaming/)
- [Gaming with CachyOS Guide](https://wiki.cachyos.org/configuration/gaming/)
- [proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom)
- [gamescope](https://github.com/ValveSoftware/gamescope)
- [dxvk](https://github.com/doitsujin/dxvk)
- [dxvk-nvapi](https://github.com/jp7677/dxvk-nvapi)
- [vkd3d-proton](https://github.com/HansKristian-Work/vkd3d-proton)

## Issues

Known issues and workarounds

### Brave Origin

KeePassXC browser integration does not support Brave Origin out of the box

- https://github.com/keepassxreboot/keepassxc/issues/13263
- https://www.reddit.com/r/KeePass/comments/1tfxulw/keepassxc_plugin_not_connecting_on_brave/

### dbus

Multiple errors like `dbus-broker-launch[1170]: Ignoring duplicate name 'ca.desrt.dconf' in service file '/usr/share//dbus-1/services/ca.desrt.dconf.service'` in journal

- https://bbs.archlinux.org/viewtopic.php?pid=2294025

### GDM

Suspends right after waking up from suspending via GNOME

- https://gitlab.gnome.org/GNOME/gdm/-/issues/1029

Workaround

Set `sleep-inactive-ac-type` & `sleep-inactive-battery-type` to `nothing` inside GDM dconf

### GNOME Settings

Journal contains multiple messages regarding GNOME Settings trying to interact with the services that were not installed

- `couldn't list homed users: GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not activate remote peer 'org.freedesktop.home1': activation request failed: unknown unit`
- `Failed to disable orca.service: GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit orca.service does not exist`
- `Failed to fetch USBGuard parameters: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name is not activatable`
- `Failed to stop gnome-user-share-webdav.service: GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit gnome-user-share-webdav.service not loaded.`
- `Failed to stop orca.service: GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit orca.service not loaded.`
- `Failed to stop rygel.service: GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit rygel.service not loaded.`

Cosmetic. No action needed.

### Intune

Intune `libgobject-2.0.so.0` coredump

- https://git.recolic.net/root/microsoft-intune-archlinux/-/issues/3

### Limine

No Bitlocker support

- https://codeberg.org/Limine/Limine/issues/12

### Lua

When `lua-luarocks` installs, its post-install script runs `make_manifest` for all Lua version trees, including `rocks-5.5/`. The `lua54-filesystem` package only populates `rocks-5.4/`. When another package like `lua-luacheck` exists in `rocks-5.5/` and declares  `luafilesystem` as a dependency, the manifest generator can't find the corresponding  `rock_manifest` there — hence the error. The install itself still succeeds — this is a non-fatal post-install hook failure. To fix this, install the Lua 5.5 variant of `lua-filesystem` with `sudo pacman -S lua-filesystem`. This populates `rocks-5.5/luafilesystem/` so the manifest can be generated correctly on future upgrades.

- https://bbs.archlinux.org/viewtopic.php?pid=2292385

### Mutter

When maximizing a window, mutter triggers unredirection (direct scanout that bypasses the compositor and writes directly to the display. On NVIDIA and Wayland, this simultaneously triggers a VRR mode transition on the LG 27UL850-W, which the driver can't handle cleanly on that monitor resulting in a blank screen. This happens due to a narrow VRR range of 40–61Hz on that monitor.

- https://gitlab.gnome.org/GNOME/mutter/-/issues/1410
- https://gitlab.gnome.org/GNOME/mutter/-/issues/3419

Workaround

Extension `unredirect` prevents mutter from trigerring unredirection but that's a global change. Instead, VRR is disabled on LG 27UL850-W via `monitors.xml`.

### NetworkManager

Journal contains multiple `NetworkManager-initrd.service: Two services allocated for the same bus name org.freedesktop.NetworkManager, refusing operation.` on every boot. The `initrd`'s throwaway NetworkManager instance loses a D-Bus name race against the real NetworkManager service and gets logged as a conflict.

- https://bbs.archlinux.org/viewtopic.php?id=308415
- https://bbs.archlinux.org/viewtopic.php?id=307879

Workaround

Mask `NetworkManager-initrd.service` via `systemctl mask NetworkManager-initrd.service` before `mkinitcpio`

### Pacman

Pacman 7.0 introduced sandboxed downloading where temporary `download-*` dirs are owned by `alpm:alpm`. Pacman 7.1 worsened it — a fix for an edge case broke cleanup in normal successful transactions. This results in leaving `/var/cache/pacman/pkg/download-*` files behind.

- https://gitlab.archlinux.org/pacman/pacman/-/work_items/297

Workaround

```bash
sudo rm -rf /var/cache/pacman/pkg/download-*
```

### WirePlumber

Journal contains multiple `spa.bluez5.midi: org.bluez.GattManager1.RegisterApplication() failed: GDBus.Error:org.freedesktop.DBus.Error.UnknownMethod: Invalid method call` (and the same for `spa.bluez5.midi.server`), on every session start. WirePlumber's Bluetooth MIDI module always tries to register a GATT MIDI service with `bluez` on startup regardless of whether a BLE MIDI device is present, and this `bluez` version doesn't implement the method it calls.

Workaround

Disable the `monitor.bluez-midi` feature via `wireplumber.profiles.main` in `~/.config/wireplumber/wireplumber.conf.d/disable-bluez-midi.conf`

