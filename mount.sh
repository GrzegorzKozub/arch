set -e -o verbose

# validation

[[ ! $MY_EFI_PART || ! $MY_ARCH_PART ]] && exit 1
[[ $(lsblk -lno PATH,PARTTYPE | grep -i 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' | cut -d' ' -f1) == $MY_EFI_PART ]] || exit 1
[[ $(lsblk -lno PATH,PARTTYPE | grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' | cut -d' ' -f1) == $MY_ARCH_PART ]] || exit 1

# unlock

cryptsetup luksOpen $MY_ARCH_PART lvm
sleep 1

# mount

if [[ ! $(mount | grep 'vg1-backup on /mnt') ]]; then mount /dev/mapper/vg1-backup /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep "$MY_EFI_PART on /mnt/boot") ]]; then mount $MY_EFI_PART /mnt/boot; fi

