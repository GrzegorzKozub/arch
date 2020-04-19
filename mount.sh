set -e -o verbose

# mount

EFI_PART="$(lsblk -lno PATH,PARTTYPE | grep -i 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' | cut -d' ' -f1)"

if [[ ! $(mount | grep 'vg1-backup on /mnt') ]]; then mount /dev/mapper/vg1-backup /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep "$EFI_PART on /mnt/boot") ]]; then mount $EFI_PART /mnt/boot; fi

unset EFI_PART

