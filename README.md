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
2. Run `source ~/arch/drifter.zsh`, `source ~/arch/pascal.zsh` or `source ~/arch/turing.zsh`
3. Once per machine, run `~/arch/disk.sh`, otherwise run `~/arch/unlock.zsh`
4. Run `~/arch/system.zsh`
5. Once per machine, run `~/arch/boot.zsh`
6. Reboot to Arch and login as normal user
7. Run `~/code/arch/services.zsh`
8. Reboot to Gnome, login as normal user and connect to internet
9. Run `~/code/arch/apps.zsh`
10. Reboot

## Manual config

1. Disable wifi on `turing`
2. Setup `networkmanager-openconnect`
  - Work around missing `--no-dtls` support as per [this issue](https://gitlab.gnome.org/GNOME/NetworkManager-openconnect/issues/7) by executing `iptables -I OUTPUT -d <VPN server> -p udp --dport 443 -j REJECT`
3. Setup Chrome
  - For Chromium, add Polish language and enable it for spell check
  - For Google Chrome, enable enhanced spell check
  - Disable continuing in the background
  - Enable `chrome://flags/#enable-webrtc-pipewire-capturer`
4. Setup Postman, Slack and KeePassXC
5. Run `windows.zsh`

