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
  ```
  rm -rf /run/media/$USER/ARCHISO/(arch|EFI|loader|syslinux|shellx64.efi)
  cp -r ~/code/arch/archiso/usb/* /run/media/$USER/ARCHISO
  ```

## Installation

1. Boot from archiso
2. Run `source ~/arch/ampere.zsh`, `source ~/arch/drifter.zsh` or `source ~/arch/turing.zsh`
3. Once per machine, run `~/arch/disk.sh`, otherwise run `~/arch/unlock.zsh`
4. Run `~/arch/system.zsh`
5. Once per machine, run `~/arch/boot.zsh`
6. Reboot to Arch and login as normal user
7. Run `~/code/arch/services.zsh`
8. Reboot to Gnome, login as normal user and connect to internet
9. Run `~/code/arch/apps.zsh`
10. Reboot

## Manual config

1. Chrome
  - Sync your Google accounts
  - See that English and Polish languages are enabled
  - Enable enhanced spell check for all lanuages
  - Disable continuing in the background
  - Sign in to your sites and setup Hangouts
  - Enable `chrome://flags/#enable-webrtc-pipewire-capturer`
  - Remove the Hangouts link from `~/.local/share/applications`
2. KeePassXC
  - Open your databases
  - Only show attachment, title and username columns
  - Fit columns to window
3. Hide the menu in Slack
4. Change the font to `Fira Code Retina` and tab size to `2` in Postman
5. Hide recommended extensions and disable tweet feedback icon in Visual Studio Code
6. Gnome
  - Reorder the icons
  - Add VPN server
  - Remove the `~/.gnome` dir
7. Clone the work repo, run `update.zsh` and setup `.env` files
8. Run `windows.zsh`

