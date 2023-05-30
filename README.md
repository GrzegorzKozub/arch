# Arch

Automated Arch Linux installation

## Prerequisites

* Windows, along with the EFI partition are already installed. EFI partition size is increased to 512 MB
* There's at least 80 GB unassigned space on the disk for Arch
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows)

## Archiso

1. Create a DOS partition table on the pendrive
2. Add a FAT32 partition with the boot flag
3. Label the partition with `sudo mlabel -i /dev/sda1 ::archiso`
4. Build with `~/code/arch/archiso.zsh`
5. Copy with
  ```zsh
  rm -rf /run/media/$USER/ARCHISO/(arch|EFI|loader|syslinux|shellx64.efi)
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
8. Reboot to Gnome, login as normal user and connect to internet
9. Run `~/code/arch/apps.zsh`
10. Reboot

### Manual config

1. Brave
  - Setup your profiles
  - Set as default browser
  - Hide bookmarks
  - Hide side pannel button
  - Enable wide address bar
  - Only allow suggestions from top sites, history and bookmarks
  - Hide Brave Rewards button
  - Hide tab search button
  - Cycle through the most recently used tabs with Ctrl-Tab
  - Disable everything except background images on the dashboard
  - Enable search and URL autocompletion
  - Disable daily usage ping and diagnostic reports
  - Join the Sync Chain and sync everything
  - Don't allow sites to send notifications
  - Install your extensions
  - Disable wallets and hide the button
  - Don't offer to save passwords and don't sign in automatically
  - Add Polish and enable spell check for it
  - Don't offer to translate pages
  - Don't ask where to save downloaded files
  - Don't show Wayback Machine prompts on 404 pages
  - Don't continue running background apps
  - Enable Memory Saver
  - Enable `brave://flags/#enable-webrtc-pipewire-capturer`
  - Sign in to your sites
  - Teams
    - Disable surveys
    - Disable optional connected experiences
    - Disable missed activity emails
    - Disable notification banners
    - Don't show message preview
    - Don't play sound for incoming calls and notifications
    - Show notifications in feed or not at all
    - Open files in browser
    - Block notifications in browser
    - Allow camera and microphone in browser
2. KeePassXC
  - Open your databases
  - Only show attachment, title and username columns
  - Fit columns to window
3. Change the font to `Cascadia Code` and tab size to `2` in Postman
4. Hide recommended extensions and disable tweet feedback icon in Visual Studio Code
5. Gnome
  - Set display scale to 200% on drifter
  - Reorder the icons
  - Add VPN server
  - Select the sound device and set volume to 50%
  - Remove the `~/.gnome` dir
6. Clone apsis repo, run `repos.zsh`, setup `.env` files and token env variables
7. Fix window sizes and positions

## Wayland

Currently enabled on Intel. Kitty and Visual Studio Code run in native Wayland. Brave and KeePassXC run on XWayland.

### Problems

- Last open window is not active due to [this mutter bug](https://gitlab.gnome.org/GNOME/mutter/-/issues/2690)
- Text scaling factor is not supported by the apps and Gnome experimental fractional scaling is slow
- KeePassXC auto-type is not supported
- Kitty client-side decorations (CSD) are ugly on Gnome (Plasma provides server-side decorations)
- `redshift` is not compatible (use `gammastep`)
- Brave graphical glitches on NVIDIA
- `nvidia-settings` is not compatible (coolbits, undervolting and overclocking) and PowerMizer doesn't work as soon as `nvidia_drm.modeset=1` is enabled
- Game performance on NVIDIA is worse compared to Xorg
- Games stutter on Gnome (fine on Plasma)

### Enabling on NVIDIA

- Add `nvidia_drm.modeset=1` kernel module setting
- Run `ln -s /dev/null /etc/udev/rules.d/61-gdm.rules`
- Make sure there's no `WaylandEnable=false` in `/etc/gdm/custom.conf`
- [Fix Gnome shell suspend](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend)

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
  ```zsh
  mv $XDG_DATA_HOME/Steam /run/media/$USER/games/
  ln -s /run/media/$USER/games/Steam $XDG_DATA_HOME/Steam
  ```

### Launch options

Template

```
<variables> gamemoderun strangle --vulkan-only --vsync 0 60 %command%`
```

Default variables

```
LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" MANGOHUD=1 PROTON_ENABLE_NVAPI=1
```

Options

- `DXVK_FRAME_RATE=60` - libstrangle does not work with DXVK
- `VKD3D_CONFIG=dxr11` - DXR 1.1 (ray tracing)
- `WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_MODE=ultra WINE_FULLSCREEN_FSR_STRENGTH=2` - FSR 1.0

Games

- Cemu, VULKAN
  - `LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" PROTON_ENABLE_NVAPI=1 python3 ./save_sync mangohud gamemoderun %command% -f -g "<game file>"`
- Elden Ring, VKD3D
  - `./er-patcher --rate 144 -vcas -- env LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" MANGOHUD=1 PROTON_ENABLE_NVAPI=1 WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_MODE=ultra WINE_FULLSCREEN_FSR_STRENGTH=2 gamemoderun strangle --vulkan-only --vsync 0 60 %command%`

### References

- [dxvk](https://github.com/doitsujin/dxvk)
- [gamescope](https://github.com/Plagman/gamescope)
- [libstrangle](https://gitlab.com/torkel104/libstrangle)
- [MangoHud](https://github.com/flightlessmango/MangoHud)
- [proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom)
- [vkd3d-proton](https://github.com/HansKristian-Work/vkd3d-proton)

## Useful packages

- Fonts
  - `font-manager`
  - `gnome-characters`

