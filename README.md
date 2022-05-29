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

## Manual config

1. Brave
  - Setup your profiles
  - Set as default browser
  - Hide bookmarks
  - Enable wide address bar
  - Hide tab search button
  - Hide Brave Rewards button
  - Disable everything except background images on the dashboard
  - Enable search and URL autocompletion
  - Join the Sync Chain and sync everything
  - Don't allow sites to send notifications
  - Install your extensions
  - Disable Brave Wallet and hide the button
  - Don't offer to save passwords and don't sign in automatically
  - Add Polish and enable spell check for it
  - Don't offer to translate pages
  - Don't ask where to save downloaded files
  - Don't show Wayback Machine prompts on 404 pages
  - Don't continue running background apps
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
3. Change the font to `Fira Code Retina` and tab size to `2` in Postman
4. Hide recommended extensions and disable tweet feedback icon in Visual Studio Code
5. Gnome
  - Reorder the icons
  - Add VPN server
  - Select the sound device and set volume to 50%
  - Remove the `~/.gnome` dir
6. Clone the work repo, run `update.zsh` and setup `.env` files
7. Fix window size and position

## Windows VM

During the installation, put Windows and [virtio-win](https://github.com/virtio-win/virtio-win-pkg-scripts) iso in `$DIR`. Install disk, graphics card and network card drivers from virtio-win. Disable fast startup. Map `\\10.0.2.4\qemu` as network drive.

For clipboard or folder sharing install `virt-viewer` on host and [guest tools and webdav daemon](https://www.spice-space.org/download.html) on guest.

To reduce the image size after freeing up space on guest, first defragment the drives and run `sdelete -z` on guest, then run `qemu-img convert -O qcow2 from.cow to.cow`.

## Games

1. Run `~/code/arch/games.zsh`
2. Reboot
3. Start Steam
4. Once per machine, configure Steam and specifically
  - Enable Shader Pre-Caching
  - Allow background processing of Vulkan shaders
  - Enable Steam Play for supported titles
  - Enable Steam Play for all other titles
  - Run other titles with Proton Experimental
  - For Proton Experimental tool, select bleeding-edge beta
  - For your games, set compatibility to Proton-GE
  - For your games, set launch options to `DXVK_ASYNC=1 MANGOHUD=1 PROTON_ENABLE_NVAPI=1 VKD3D_CONFIG=upload_hvv WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_STRENGTH=2 gamemoderun %command%`
  - To limit FPS with `libstrangle` instead of `mangohud`, add `strangle --vulkan-only --vsync 0 60`
5. Once per machine, move Steam to games disk with
  ```zsh
  mv ${XDG_DATA_HOME:-~/.local/share}/Steam /run/media/$USER/games/
  ln -s /run/media/$USER/games/Steam ${XDG_DATA_HOME:-~/.local/share}/Steam
  ```
6. Dark Souls 3
  - Download [ds3-patcher](https://github.com/grzegorzkozub/ds3-patcher) to the game dir and `chmod u+x ds3_patcher`
  - Set launch options to `./ds3_patcher -s -- env DXVK_ASYNC=1 LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" MANGOHUD=1 PROTON_ENABLE_NVAPI=1 VKD3D_CONFIG=upload_hvv WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_STRENGTH=2 gamemoderun %command%`
7. Elden Ring
  - Download [er-patcher](https://github.com/gurrgur/er-patcher) to the game dir and `chmod u+x er-patcher`
  - Set launch options to `./er-patcher --rate 144 -vcas -- env DXVK_ASYNC=1 LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" MANGOHUD=1 PROTON_ENABLE_NVAPI=1 VKD3D_CONFIG=upload_hvv WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_STRENGTH=2 gamemoderun %command%`
8. Insurgency Sandstorm
  - Set launch options to `DXVK_ASYNC=1 LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" MANGOHUD=1 PROTON_ENABLE_NVAPI=1 VKD3D_CONFIG=upload_hvv WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_STRENGTH=2 gamemoderun %command% -dx12 -noglobalinvalidation -nominidumps -useallavailablecores`

