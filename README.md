# Arch

Installing Arch Linux on Dell XPS 13 9360

## Prerequisites

* Windows, along with the EFI partition are already installed. EFI partition is `dev/nvme0n1p2`
* There's enough unassigned space on the disk for Arch. It's going to become `dev/nvme0n1p7`
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows)

## Archiso

1. Download the ISO from [here](https://www.archlinux.org/download/)
2. Create the USB following [this guide](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_Rufus) but use ISO mode and not DD mode
3. Add `video=1280x720` to `options` in `loader\entries\archiso-x86_64.conf`
4. Make the USB compatible with Secure Boot following [this answer](https://unix.stackexchange.com/questions/320078/how-to-boot-arch-linux-installation-medium-with-secure-boot-enabled)
5. Clone this repository or at least `archiso.sh` to `.Arch` folder on the USB. When booted from archiso it will be mounted at `/run/archiso/bootmnt/.Arch`
6. When booting from the USB for the first time, enrol hash for `arch/boot/x86_64/vmlinuz` and `EFI/boot/loader.efi`

## Arch and Gnome

1. Boot from archiso
2. Run `archiso.sh` to setup the session and clone these scripts
3. Once per machine, run `disk.sh` to create the encrypted partition and logical volumes on it. Otherwise run `unlock.sh` to open the partition
4. Run `system.sh` to install Arch with Gnome and perform basic config
5. Once per machine, run `boot.sh` to install boot manager with secure boot support

## Apps

1. Reboot to Arch and login as normal user
2. Run `~/Code/Arch/config.sh` to finish configuring Arch and Gnome
3. Run `~/Code/Arch/apps.sh` to install and configure the apps

