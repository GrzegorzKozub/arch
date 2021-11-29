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
  - Hide Brave Rewards button
  - Disable everything except background images on the dashboard
  - Enable search and URL autocompletion
  - Join the Sync Chain and sync everything
  - Install your extensions
  - Disable Brave Wallet and hide the button
  - Don't offer to save passwords and don't sign in automatically
  - Add Polish and enable spell check for it
  - Don't offer to translate pages
  - Don't ask where to save downloaded files
  - Don't show Wayback Machine prompts on 404 pages
  - Don't continue running background apps
  - Sign in to your sites and allow notifications, camera and microphone where needed (including Hangouts)
  - Enable `brave://flags/#enable-webrtc-pipewire-capturer`
2. Chrome
  - Setup your profiles and sync your Google accounts
  - Set as default browser
  - See that English and Polish languages are enabled
  - Enable enhanced spell check for all lanuages
  - Disable continuing in the background
  - Sign in to your sites and allow notifications, camera and microphone where needed (including Hangouts)
  - Enable `chrome://flags/#enable-webrtc-pipewire-capturer`
  - Remove the Hangouts link from `~/.local/share/applications`
3. KeePassXC
  - Open your databases
  - Only show attachment, title and username columns
  - Fit columns to window
4. Hide the menu in Slack
5. Teams
  - Disable autostart
  - Disable logging
  - Turn off animations
  - Disable surveys
  - Disable optional connected experiences
  - Disable missed activity emails
  - Don't play sound for incoming calls and notifications
  - Open files in the browser
6. Change the font to `Fira Code Retina` and tab size to `2` in Postman
7. Hide recommended extensions and disable tweet feedback icon in Visual Studio Code
9. Gnome
  - Reorder the icons
  - Add VPN server
  - Remove the `~/.gnome` dir
9. Clone the work repo, run `update.zsh` and setup `.env` files
10. Run `windows.zsh`

