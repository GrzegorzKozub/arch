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
5. Copy this arch directory to .arch` folder on the USB. When booted from archiso it will be mounted at `/run/archiso/bootmnt/.arch`
6. When booting from the USB for the first time, enrol hash for `arch/boot/x86_64/vmlinuz` and `EFI/boot/loader.efi`

## Installation

1. Boot from archiso
2. Run `/run/archiso/bootmnt/.arch/arch/archiso.sh`. Puts these scripts into root's `~/arch`
3. Once per machine run `~/arch/disk.sh`
4. Run `~/arch/system.sh`. Puts these scripts into normal user's `~/code/arch`
5. Once per machine run `~/arch/boot.sh`
6. Reboot to Arch and login as normal user
7. Run `~/code/arch/services.sh`
8. Reboot to Gnome, login as normal user, connect to WiFi and ensure archiso is mounted
9. Run `~/code/arch/apps.zsh` and close the terminal
10. Open the terminal again for some installations to complete
11. Reboot for some settings to take effect

## Maual configuration

1. Setup Gnome
  - Install Dim On Battery Power and Tray Icons shell extensions
2. Setup Chrome
  - Disable continuing in the background
  - Enable chrome://flags/#enable-webrtc-pipewire-capturer
  - Install uBlock
3. Setup Dropbox
  - Exclude unwanted dirs from sync

