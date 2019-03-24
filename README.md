# Arch

Installing Arch Linux on Dell XPS 13 9360

## Prerequisites

* Windows, along with the EFI partition are already installed. EFI partition is `dev/nvme0n1p2`
* There's enough unassigned space on the disk for Arch. It's going to become `dev/nvme0n1p6`
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows)

## Create archiso USB

1. Download the ISO from [here](https://www.archlinux.org/download/)
2. Create the USB following [this guide](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_Rufus) but use ISO mode and not DD mode
3. Add `video=1280x720` to `options` in `loader\entries\archiso-x86_64.conf`
4. Make the USB compatible with Secure Boot following [this answer](https://unix.stackexchange.com/questions/320078/how-to-boot-arch-linux-installation-medium-with-secure-boot-enabled)
5. Clone this repository to `.greg/Arch` folder on the USB
6. When booting from the USB for the first time, enrol hash for `arch/boot/x86_64/vmlinuz` and `EFI/boot/loader.efi`

## Install Arch

The scripts called out below can be run from `/run/archiso/bootmnt/.greg/Arch`

1. Boot from archiso
2. Run `archiso.sh` to setup archiso session
3. Once per machine, run `disk.sh` to create the encrypted partition and logical volumes on it. Otherwise run `unlock.sh` to open the partition.
4. Run `system.sh` to install Arch with Gnome and perform basic config
5. Once per machine, run `boot.sh` to install boot manager with secure boot support.

## Install the apps

1. Reboot to Arch and login as normal user
2. Run `~/Code/Arch/apps.sh`

## Configure Gnome

* Connect to Internet
* Change language formats and input source to Polish
* Enable automatic suspend
* Enable tap to click
* Enable night light
* Disable sound effects
* Set Super+D as keyboard shortcut for Hide all normal windows
* Change font scaling to 1.25 in Tweaks
* Setup Terminal
* Install Bing Wallpaper Changer
* Install Dim On Battery Power extension

