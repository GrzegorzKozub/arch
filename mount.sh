set -e -o verbose

cryptsetup luksOpen /dev/nvme0n1p7 lvm
sleep 1

if [[ ! $(mount | grep 'vg1-backup on /mnt') ]]; then mount /dev/mapper/vg1-backup /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep 'nvme0n1p2 on /mnt/boot') ]]; then mount /dev/nvme0n1p2 /mnt/boot; fi

