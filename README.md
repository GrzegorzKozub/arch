# Arch

Automated Arch Linux installation

## Prerequisites

* Windows, along with the EFI partition are already installed. EFI partition size is increased to 512 MB
* There's at least 80 GB unassigned space on the disk for Arch
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows)

## Archiso

1. Download the ISO from [here](https://www.archlinux.org/download/)
2. Create the USB following [this guide](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_Rufus) but use ISO mode and not DD mode
3. Add `video=1280x720` to `options` in `loader\entries\archiso-x86_64.conf`
4. Make the USB compatible with Secure Boot following [this answer](https://unix.stackexchange.com/questions/320078/how-to-boot-arch-linux-installation-medium-with-secure-boot-enabled)
5. Copy this arch directory to `.bootstrap` folder on the USB. When booted from archiso it will be mounted at `/run/archiso/bootmnt/.bootstrap`
6. When booting from the USB for the first time, enrol hash for `arch/boot/x86_64/vmlinuz` and `EFI/boot/loader.efi`

## Installation

1. Boot from archiso
2. Run `/run/archiso/bootmnt/.bootstrap/arch/archiso.sh`. Puts these scripts into root's `~/arch`
3. Run `source ~/arch/drifter.sh` or `source ~/arch/turing.sh`
4. Once per machine run `~/arch/disk.sh`, otherwise run `~/arch/unlock.sh`
5. Run `~/arch/system.sh`. Puts these scripts into normal user's `~/code/arch`
6. Once per machine run `~/arch/boot.sh`
7. Reboot to Arch and login as normal user
8. Run `~/code/arch/services.sh`
9. Reboot to Gnome, login as normal user, connect to WiFi and ensure archiso is mounted
10. Run `~/code/arch/apps.zsh`
11. Reboot for some settings to take effect

## Maual config

1. Setup Gnome
  - Install Dynamic Panel Transparency shell extension
2. Setup Chrome
  - Disable continuing in the background
  - Enable enhanced spell check
  - Enable chrome://flags/#enable-webrtc-pipewire-capturer
3. Setup networkmanager-openconnect
  - Work around missing `--no-dtls` support as per [this issue](https://gitlab.gnome.org/GNOME/NetworkManager-openconnect/issues/7) by executing `iptables -I OUTPUT -d <VPN server> -p udp --dport 443 -j REJECT`
4. Setup printer
  - Run `printer.sh`
  - Add your printer using Printer Settings app

## Troubleshooting

To skip Gnome when upgrading system put this into `/etc/pacman.conf`:

```
IgnorePkg   = adwaita* clutter cogl desktop-file* gcr geoclue gjs *glib* gnome* *gobject* gsettings* *gtk* js68 lib* nm-connection-editor pipewire polkit poppler *spi2* *totem* *vte* wayland* xcb* xdg*
IgnoreGroup = gnome*
```
