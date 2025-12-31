# Arch

Automated Arch Linux installation

## Archiso

1. Create a DOS partition table on a pendrive
2. Add a FAT32 partition with the boot flag
3. Prepare the partition for the `archisosearchuuid` param
  - Set the UUID to a known value with `sudo mlabel -i /dev/sdb1 :: -N 12345678`
  - Verify with `lsblk -lno PATH,FSTYPE,UUID`
4. Label the partition with `sudo mlabel -i /dev/sdb1 ::archiso`
5. Build with `~/code/arch/archiso.zsh`

## Installation

1. Boot from archiso
2. Run `source ~/arch/drifter.zsh`, `source ~/arch/player.zsh` or `source ~/arch/worker.zsh`
3. Use `cfdisk` to create Linux filesystem partition as `$MY_ARCH_PART` (`cfdisk` can sort partitions)
4. Once per machine, run `~/arch/disk.sh`, otherwise run `~/arch/unlock.zsh`
5. Run `~/arch/system.zsh`
6. Once per machine, run `~/arch/boot.zsh`
7. Reboot to Arch and login as normal user
8. Run `~/code/arch/services.zsh`
9. Reboot to GNOME, login as normal user and connect to internet on drifter
10. Once per machine, prepare secrets
11. Run `~/code/arch/apps.zsh` and `~/code/arch/work.zsh` on drifter and worker
12. Reboot
13. Once per machine, run `~/code/arch/secboot.zsh` (backup required after)
14. Once per machine and after each `secboot.zsh` run, run `~/code/arch/crypt.zsh`
15. If required, run `~/code/arch/intune.zsh` and `~/code/arch/edge.zsh` (work)
16. Reboot & backup

### Manual config

1. GNOME
  - Set variable display refresh rate: player 240 Hz, worker 144 & 60 Hz
  - Set display scale: drifter 300%, player & worker 200%
  - Remove all folders from dash
2. KeePassXC
  - Open your databases
  - Only show title and username columns, also in search
  - Fit to window, also in search
3. Brave
  - Join the Sync Chain and sync everything
  - Setup your profiles
  - Set as default browser
  - Disable everything except background images on the dashboard
  - Hide all buttons except Forward in toolbar customization
  - Don't show tab groups in bookmarks
  - Don't allow suggestions Leo AI Assistant
  - Use wide address bar
  - Set fixed-width font to Cascadia Code (on Windows)
  - Cycle through the most recently used tabs with Ctrl-Tab
  - Don't show Wayback Machine prompts on 404 pages
  - Don't show the number of blocked items on the Shields icon
  - Enable YouTube Anti-Shorts content filter
  - (Questionable) Disable EasyList Cookie content filter
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
  - Enable Memory Saver
  - Disable Brave VPN (on Windows)
  - Import KeePassXC extension settings from `~/code/dot/keepassxc-browser.json`
  - Connect KeePassXC databases
  - Sign in into your sites and setup passkeys
4. Visual Studio Code
  - Sign in: GitHub
  - Pick LLM
  - Hide recommended extensions
5. Zed
  - Sign in: Zed, collab panel
  - Configure LLM providers: Zed, Anthropic, GitHub Copilot Chat, Google AI, OpenAI
  - Configure edit predictions
6. Postman (work)
  - Sign in
  - Change font family to `Cascadia Code`
  - Change font size to `16`
  - Change indentation count to `2`
  - Don't send anonymous usage data
7. Teams (work)
  - Follow operating system theme
  - Switch to compact chat message density
  - Disable notification display
  - Disable all apps
8. Intune (work)
  - Sign in
  - Register device
9. Edge (work)
  - Disable everything during the first launch wizard
  - Switch to international edition and disable everything on new tab page
  - Name your profile or sign in
  - Disable Microsoft Rewards
  - Don't share browsing data with other Windows features
  - Disable everything except showing Reveal password button under Passwords and autofill
  - Block notifications
  - Disable everything under Search and connected experiences
  - Switch search engine used in address bar to Google
  - Hide favorites on toolbar
  - Don't show mini menu when selecting text
  - Disable visual search
  - Set fixed-width font to Cascadia Code (on Windows)
  - Disable everything under Copilot and sidebar
  - Don't show tab actions menu
  - Don't show tab preview on hover
  - Open tabs from the previous session on startup
  - Add Polish
  - Don't offer to translate pages that aren't in a language I read
  - Don't offer to translate videos on supported sites
  - Don't use Copilot for writing on the web
  - Don't use text prediction
  - Switch to Microsoft Editor under Writing assistance
  - Disable startup boost
  - Don't continue running background extensions and apps when Edge is closed
10. Fix window sizes and positions

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

## Colors

Monitors were calibrated as described in the [toys](https://github.com/GrzegorzKozub/toys) repo. Color profiles are loaded using `colord` via `settings.zsh`.

To test if a profile is loaded use this `dispwin` command from `argyllcms` package:

```zsh
dispwin -d1 -V ~/code/arch/home/greg/.local/share/icc/mpg321urx.icm
```

## Fonts

Comfortable settings for display scale on Wayland given the screen size and resolution:

- drifter: 300%
- player & worker: 200%

Font scaling factor is always at 1.

The aim is to standardize on the font size of `1em` or `12pt` or `16px` ([converter](https://simplecss.eu/pxtoems.html)) and achieve about 50 lines (or 40 lines on drifter) of full screen text in terminal and code editors.

Current settings:

- Ghostty & Kitty: `12pt` (or `1em` or `16px`)
- Brave, Code, Obsidian, Postman, Zed: `16px` (or `1em` or `12pt`)

## GNOME Shell extensions

Install `mutter-devkit` and run `dbus-run-session -- gnome-shell --devkit` to test & debug.

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
3. Once per machine, start and configure Steam
  - Don't sign in to Friends when Steam starts
  - Never show notification toasts
  - Enable 24-hour clock, enable Beta, set start up location to Library, don't run Steam on startup and disable update notifications
  - Leave only Store, Library, Settings and Exit Steam in taskbar preferences
  - Disable community content, hide game icons and show Steam Deck compatibility in Library
  - Disable shader pre-caching
  - Disable Steam overlay, remove overlay shortcut key, set performance monitor key to `F9` and remove screenshot key
  - Set default compatibility tool to Proton-CachyOS or Proton-GE
  - Disable Remote Play
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

