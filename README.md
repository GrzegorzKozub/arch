# Arch

Installing Arch Linux on Dell XPS 13

## Prerequisites

* Windows, along with the EFI partition are already installed. EFI partition is `dev/nvme0n1p2`
* There's enough unassigned space on the disk for Arch. It's going to become `dev/nvme0n1p7`
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows)

## Archiso

1. Download the ISO from [here](https://www.archlinux.org/download/)
2. Create the USB following [this guide](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_Rufus) but use ISO mode and not DD mode
3. Add `video=1280x720` to `options` in `loader\entries\archiso-x86_64.conf`
4. Make the USB compatible with Secure Boot following [this answer](https://unix.stackexchange.com/questions/320078/how-to-boot-arch-linux-installation-medium-with-secure-boot-enabled)
5. Copy this Arch directory to .Arch` folder on the USB. When booted from archiso it will be mounted at `/run/archiso/bootmnt/.Arch`
6. When booting from the USB for the first time, enrol hash for `arch/boot/x86_64/vmlinuz` and `EFI/boot/loader.efi`

## Installation

1. Boot from archiso
2. Run `/run/archiso/bootmnt/.Arch/Arch/archiso.sh`. Puts these scripts into root's `~/Arch`
3. Once per machine run `~/Arch/disk.sh`, otherwise run `~/Arch/unlock.sh`
4. Run `~/Arch/system.sh`. Puts these scripts into normal user's `~/Arch`
5. Once per machine run `~/Arch/boot.sh`
6. Reboot to Arch and login as normal user
7. Run `~/Arch/config.sh`
8. Reboot to Gnome, login as normal user and connect to WiFi
9. With archiso plugged in, run `~/Arch/apps.sh`
10. Reboot for some settings to take effect

## Maual configuration

1. Setup Gnome
  - Mute system sounds
  - Install Dim On Battery Power and Tray Icons shell extensions
2. Setup Chromium
  - Disable continuing in the background
  - Install uBlock
3. Setup Dropbox
  - Exclude unwanted dirs from sync

