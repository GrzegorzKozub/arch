set -e -o verbose

# mount

if [[ ! $(mount | grep "vg1-backup on /mnt") ]]; then mount /dev/mapper/vg1-backup /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep "nvme0n1p2 on /mnt/boot") ]]; then mount /dev/nvme0n1p2 /mnt/boot; fi

# backup

DIR=/mnt/$(date +%Y%m%d%H%M)

mkdir $DIR

fsarchiver savefs $DIR/root.fsa /dev/mapper/vg1-root

cp /mnt/boot/*.img $DIR
cp /mnt/boot/vmlinuz-linux $DIR
cp -r /mnt/boot/loader $DIR

unset DIR

# unmount

sudo umount -R /mnt

