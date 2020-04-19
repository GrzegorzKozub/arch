set -e -o verbose

# validation

[[ $MY_DISK ]] || exit 1
[[ $MY_EFI_PART && $(lsblk -lno PATH,PARTTYPE | grep -i 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' | cut -d' ' -f1) == $MY_EFI_PART ]] || exit 1
[[ $MY_EFI_PART_NBR ]] || exit 1
[[ $MY_ARCH_PART && $(lsblk -lno PATH,PARTTYPE | grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' | cut -d' ' -f1) == $MY_ARCH_PART ]] || exit 1

# mount

if [[ ! $(swapon) ]]; then swapon /dev/mapper/vg1-swap; fi
if [[ ! $(mount | grep 'vg1-root on /mnt') ]]; then mount /dev/mapper/vg1-root /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep "$MY_EFI_PART on /mnt/boot") ]]; then mount $MY_EFI_PART /mnt/boot; fi

# boot manager with secure boot support

cp -r `dirname $0`/../arch /mnt/root
arch-chroot /mnt ~/arch/boot2.sh
rm -rf /mnt/root/arch

# unmount

swapoff /dev/mapper/vg1-swap
umount -R /mnt

