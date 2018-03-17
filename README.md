# Arch

Installing Arch Linux on Dell XPS 13 9360.

## Assumptions

* Windows, along with the EFI partition are already installed. EFI partition is `dev/nvme0n1p2`.
* There's 40 GB unassigned space on the disk for Arch. It's going to become `dev/nvme0n1p6`.
* In Windows, real time is set to UTC following [this guide](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows).

## Create archiso USB

1. Download the ISO from [here](https://www.archlinux.org/download/).
2. Create the USB following [this guide](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_Rufus).
3. Add `video=1280x720` to `options` in `loader\entries\archiso-x86_64.conf`.
4. Make the USB compatible with Secure Boot following [this answer](https://unix.stackexchange.com/questions/320078/how-to-boot-arch-linux-installation-medium-with-secure-boot-enabled).

## Prepare archiso session

1. Boot from archiso.
2. Update system clock:

```
timedatectl set-ntp true
```

3. Connect to the Internet:

```
wifi-menu
```

4. Update `pacman` mirrors:

```
pacman -Sy reflector
reflector --country Poland --sort rate --save /etc/pacman.d/mirrorlist
```

## Prepare disk

1. If not done previously on this machine, create a partition, encrypt it with Luks, create LVM volumes and create filesystems:

```
cfdisk /dev/nvme0n1
cryptsetup luksFormat --type luks2 /dev/nvme0n1p6
cryptsetup luksOpen /dev/nvme0n1p6 lvm
pvcreate /dev/mapper/lvm
vgcreate vg1 /dev/mapper/lvm
lvcreate --size 8G vg1 --name swap
lvcreate -l 50%FREE vg1 -n root
lvcreate -l 100%FREE vg1 -n backup
mkswap /dev/mapper/vg1-swap
mkfs.ext4 /dev/mapper/vg1-root
mkfs.ext4 /dev/mapper/vg1-backup
```

2. Otherwise, just unlock the partition:

```
cryptsetup luksOpen /dev/nvme0n1p6 lvm
```

## Install main operating system

1. Mount the volumes:

```
swapon /dev/mapper/vg1-swap
mount /dev/mapper/vg1-root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
```

2. Remove the boot files from the previous installations:

```
rm /mnt/boot/*.img
rm /mnt/boot/vmlinuz-linux
```

3. Install base system and generate `fstab`:

```
pacstrap /mnt base base-devel sudo reflector dialog wpa_supplicant zsh intel-ucode
genfstab -U /mnt > /mnt/etc/fstab
```

4. Change root to the fresh system:

```
arch-chroot /mnt
```

5. Set time zone:

```
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
```

6. Configure locale and keyboard layout:

```
nano /etc/locale.gen

  en_US.UTF-8 UTF-8
  pl_PL.UTF-8 UTF-8

locale-gen
nano /etc/locale.conf

  LANG=en_US.UTF-8
  LC_MEASUREMENT=pl_PL.UTF-8
  LC_MONETARY=pl_PL.UTF-8
  LC_NUMERIC=pl_PL.UTF-8
  LC_PAPER=pl_PL.UTF-8
  LC_TIME=pl_PL.UTF-8

nano /etc/vconsole.conf

  KEYMAP=pl2
  FONT=Lat2-Terminus16.psfu.gz
  FONT_MAP=8859-2
```

7. Configure `hostname` and `hosts`:

```
echo drifter > /etc/hostname
nano /etc/hosts

  127.0.0.1 localhost
  ::1       localhost
  127.0.1.1 drifter.localdomain drifter
```

8. Configure and generate `initramfs`:

```
nano /etc/mkinitcpio.conf

  HOOKS=(... encrypt lvm2 resume ... filesystems ...)

mkinitcpio -p linux
```

9. Set `root` password:

```
passwd
```

10. Create a regular user:

```
useradd -m -g users -G wheel -s /bin/zsh greg
passwd greg
EDITOR=nano visudo

  greg ALL=(ALL) ALL
```

11. If not done previously on this machine, install and configure the boot manager:

```
bootctl --path=/boot install
nano /boot/loader/loader.conf

  timeout   1
  default   arch

blkid -s UUID -o value /dev/nvme0n1p6 > /boot/loader/entries/arch.conf
nano /boot/loader/entries/arch.conf

  title   Arch
  linux   /vmlinuz-linux
  initrd  /intel-ucode.img
  initrd  /initramfs-linux.img
  options cryptdevice=UUID=<blkid output>:vg1 root=/dev/mapper/vg1-root resume=/dev/mapper/vg1-swap rw video=1280x720
```

12. If not done previously on this machine, add Secure Boot support:

```
pacman -S efibootmgr
su greg
cd ~
mkdir AUR
cd AUR
git clone https://aur.archlinux.org/preloader-signed.git
cd preloader-signed
makepkg -si --noconfirm
exit
cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi
efibootmgr --disk /dev/nvme0n1 --part 2 --create --label "Linux Boot Manager" --loader /EFI/systemd/PreLoader.efi
efibootmgr --delete-bootnum --bootnum <previous Linux Boot Manager number>
efibootmgr --bootorder <preferred boot order>
```

13. Return to archiso and unmount:

```
exit
umount -R /mnt
```

14. Reboot and login to the fresh system.
15. Update the system clock:

```
timedatectl set-ntp true
```

## Install backup operating system

Prepare archiso session and prepare disk following the steps above. Then go through the same steps as for installing main operating system, with these exceptions:

* When mounting the volumes, instead of `/dev/mapper/vg1-root` use `/dev/mapper/vg1-backup`.
* When doing `pacstrap`, install `base dialog reflector intel-ucode fsarchiver wpa_supplicant`.
* Don't create a regular user.
* Don't install the boot manager again. Just add `/boot/loader/entries/fsarchiver.conf`, give this entry `FSArchiver` title and instead of `/dev/mapper/vg1-root` use `/dev/mapper/vg1-backup`.
* Don't add Secure Boot support again.

## Install GNOME

1. Connect to the Internet:

```
wifi-menu
```

2. Install GNOME:

```
pacman -S xf86-video-intel xorg-server gnome gnome-tweak-tool networkmanager
```

3. Make GNOME load on startup:

```
systemctl enable gdm.service
systemctl enable NetworkManager.service
```

4. Reboot.
5. Configure the user interface:

* Connect to Internet
* Change language formats and input source to Polish
* Enable automatic suspend
* Enable tap to click
* Enable night light
* Disable sound effects
* Set Super+D as keyboard shortcut for Hide all normal windows
* Change font scaling to 1.25 in Tweaks
* Setup Terminal
* Install Dim On Battery Power extension

## Install apps

Automated via `apps.sh`.

