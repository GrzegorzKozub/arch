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
2. Run `/run/archiso/bootmnt/.Arch/Arch/archiso.sh` to setup the session and clone the latest version of these scripts to `~`
3. Change directory to `~/Arch`
4. Once per machine, run `disk.sh` to create the encrypted partition and logical volumes on it. Otherwise run `unlock.sh` to open the partition
5. Run `system.sh` to install Arch with Gnome and perform basic config
6. Once per machine, run `boot.sh` to install boot manager with secure boot support
7. Reboot to Arch and login as normal user
8. While remaining in `~`, run `~/Code/Arch/config.sh` to finish configuring Arch and setup terminal
9. Reboot to Gnome, login as normal user and connect to WiFi
10. With the USB plugged in and while remaining in `~`, run `~/Code/Arch/apps.sh` to setup Gnome as well as install and configure the apps
11. Reboot for some settings to take effect

## Maual configuration

1. Install Dim On Battery Power shell extension for Gnome
2. Setup desktop apps

